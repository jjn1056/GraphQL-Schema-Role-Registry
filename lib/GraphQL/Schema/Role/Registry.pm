package GraphQL::Schema::Role::Registry;

use Module::Pluggable::Object;
use Module::Runtime;
use Moo::Role;


sub import {
  my ($class, @types) = @_;
  my $target = caller;
  foreach my $type (@types) {
    eval qq[
      package $target;
      my \$__$type;
      sub $type {
        return \$__$type ||= $class->registered_types('$type');
      }
    ];
  }
}

my %registered_types;
sub prepare_registered_types {
  my $class = shift;
  %registered_types = map {
    my $package = $_;
    $package => +{
      instance => sub {
        return Module::Runtime::use_module($package)
          ->build_type();
      },
    };
  } ($class->find_packages);
}

sub type_namespace { return shift .'::Types' }

sub package_from_type {
  my ($class, $type) = @_;
  return my $package = $class->type_namespace .'::'. $type;
}

sub resolve_registered_type_instance {
  my ($class, $package) = @_;
  if(ref($registered_types{$package}{instance}||'') eq 'CODE') {
    $registered_types{$package}{instance} = $registered_types{$package}{instance}->();
  }
  return $registered_types{$package}{instance};
}

sub registered_types {
  my ($class, $type_to_find) = @_;
  $class->prepare_registered_types unless %registered_types;
  return sort keys %registered_types unless $type_to_find;

  my $package = $class->package_from_type($type_to_find);
  die "Can't find type $type_to_find as ${\$class->package_from_type($type_to_find)}"
    unless $registered_types{$package};

  return my $found = $class->resolve_registered_type_instance($package);
}

sub find_packages {
  my $class = shift;
  return my @packages = Module::Pluggable::Object->new(
    search_path => $class,
  )->plugins;
}

sub from_registry {
  my ($class, @args) = @_;
  my $query = $class->registered_types('Query') ||
    die "No root Query type defined in ${class}::Types";
  return my $schema = $class->new(query => $query);
}

1;
