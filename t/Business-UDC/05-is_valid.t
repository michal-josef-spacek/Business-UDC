use strict;
use warnings;

use Business::UDC;
use Readonly;
use Test::More 'tests' => 12;
use Test::NoWarnings;

Readonly::Array our @RIGHT_UDCS => qw(
	0/9
	821.111(73)-31"19"
	621.397:621.395
	(075)
	"19"
	=111
);
Readonly::Array our @BAD_UDCS => qw(
	bad
	821.111+
	:821.111
	+821.111
	-31
);

# Test.
my $obj;
foreach my $right_udc (@RIGHT_UDCS) {
	$obj = Business::UDC->new($right_udc);
	is($obj->is_valid, 1, "It is valid ($right_udc).");
}

# Test.
foreach my $bad_udc (@BAD_UDCS) {
	$obj = Business::UDC->new($bad_udc);
	is($obj->is_valid, 0, "It is not valid ($bad_udc).");
}
