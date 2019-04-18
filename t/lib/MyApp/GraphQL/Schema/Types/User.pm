package MyApp::GraphQL::Schema::Types::User;

use GraphQL::Type::Scalar qw($String $Int);

use Moo;
with 'GraphQL::Schema::Role::TypeObject';

sub get_fields {
  my ($class) = @_;
  return (
    name => { type => $String },
    age => { 
      type => $Int,
    },
  );
}

1;
