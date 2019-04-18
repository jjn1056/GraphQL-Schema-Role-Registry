package MyApp::GraphQL::Schema::Types::Query;

use MyApp::GraphQL::Schema qw(User);
use GraphQL::Type::Scalar qw($ID);

use Moo;
with 'GraphQL::Schema::Role::TypeObject';

sub get_fields {
  my ($class) = @_;
  return (
    user => {
      args => { id => { type => $ID } },
      type => User,
    },
  );
}

1;
