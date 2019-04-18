use lib 't/lib';
use Test::Most;
use MyApp::GraphQL::Schema;
use GraphQL::Execution qw(execute);

ok my $schema = MyApp::GraphQL::Schema->from_registry;

use Devel::Dwarn;
Dwarn $schema;

warn $schema->to_doc;

my $results = execute(
  $schema,
  q[
    {
      user(id:"1") {
        age
        name
      }
    }
  ],
  sub {
    my ($args, $what, $more ) = @_;

    warn 1111;
    Dwarn ($args, $what);
    Dwarn keys %$more;
  },
  { context => 1 },
);

warn "....";
Dwarn $results;

done_testing;
