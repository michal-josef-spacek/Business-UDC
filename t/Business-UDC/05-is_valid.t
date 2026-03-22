use strict;
use warnings;

use Business::UDC;
use Readonly;
use Test::More 'tests' => 31;
use Test::NoWarnings;

Readonly::Array our @RIGHT_UDCS => qw(
	0/9
	821.111(73)-31"19"
	621.397:621.395
	(075)
	(075)78
	78(075)
	"19"
	=111
	821-312.5
	636.1/.5
	(084.3)911.375
	911.375(084.3)
	908(437.2)Jihlava
	821.133.1MOL
	334.72:621.3(430)AEG
	821.111(73)-32=163.42
	821.111.09
	821.111(73).09
);
Readonly::Array our @BAD_UDCS => qw(
	bad
	821.111+
	:821.111
	+821.111
	-31
	-312.5
	636.1/.
	.5
	821+.5
	821:.5
	(437.2)94
	(73).09
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
