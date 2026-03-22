use strict;
use warnings;

use Business::UDC;
use Test::More 'tests' => 3;
use Test::NoWarnings;

# Test.
my $obj = Business::UDC->new('0/9');
is($obj->error, undef, 'Get error (no error).');

# Test.
$obj = Business::UDC->new('bad');
is($obj->error, "Unrecognized input near 'bad'.",
	'Get error (Unrecognized input near \'bad\'.).');
# TODO Check error parameters
