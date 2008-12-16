
use lib 't/lib';
use Test::More;

plan tests => 2;

use MyTestView;

my $output = MyTestView->render("/foo.html");

is($output, "foo.html output", "foo.html rendered ok");

$output = MyTestView->render("/foo/bar.html");
is($output, "bar.html output", "bar.html rendered ok");
