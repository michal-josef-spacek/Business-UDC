use strict;
use warnings;

use Business::UDC;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
my $obj = Business::UDC->new('0/9');
my $ret = $obj->ast;
is_deeply(
	$ret,
	{
		'left' => {
			'modifiers' => [],
			'primary' => {
				'type' => 'NUMBER',
				'value' => 0,
			},
			'type' => 'TERM',
		},
		'operator' => '/',
		'right' => {
			'modifiers' => [],
			'primary' => {
				'type' => 'NUMBER',
				'value' => 9,
			},
			'type' => 'TERM',
		},
		'type' => 'BINARY_OP',
	},
	'Test ast structure.',
);
