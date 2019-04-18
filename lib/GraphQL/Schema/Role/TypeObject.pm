package GraphQL::Schema::Role::TypeObject;

use GraphQL::Type::Object;
use Moo::Role;

sub _guess_name {
  my $class = shift;
  my ($ns) = $class =~m/Types::(.+)?/;
  return $ns;
}

sub get_name {
  my ($class, %args) = @_;
  return my $ns = $args{type_name}
    || $class->_guess_name;
}

sub build_type {
  my ($class, %args) = @_;
  return my $type = GraphQL::Type::Object->new(
    name => $class->get_name,
    fields => +{ $class->get_fields },
  );
}

1;
