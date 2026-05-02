use strict;
use warnings;

use Business::UDC::Tokenizer qw(tokenize);
use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 16;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);

# Test.
my $ret_ar = tokenize('123');
is_deeply(
	$ret_ar,
	[
		{
			'pos' => 0,
			'type' => 'NUMBER',
			'value' => '123',
		},
	],
	'Tokenize simple number (123).',
);

# Test.
$ret_ar = tokenize('123.4');
is_deeply(
	$ret_ar,
	[
		{
			'pos' => 0,
			'type' => 'NUMBER',
			'value' => '123.4',
		},
	],
	'Tokenize decimal number with one dot (123.4).',
);

# Test.
$ret_ar = tokenize('811.162.3');
is_deeply(
	$ret_ar,
	[
		{
			'pos' => 0,
			'type' => 'NUMBER',
			'value' => '811.162.3',
		},
	],
	'Tokenize decimal number with two dots (811.162.3).',
);

# Test.
$ret_ar = tokenize('78.03.011.26');
is_deeply(
	$ret_ar,
	[
		{
			'pos' => 0,
			'type' => 'NUMBER',
			'value' => '78.03.011.26',
		},
	],
	'Tokenize decimal number with three dots (78.03.011.26).',
);

# Test.
$ret_ar = tokenize('78.089.6.087.6');
is_deeply(
	$ret_ar,
	[
		{
			'pos' => 0,
			'type' => 'NUMBER',
			'value' => '78.089.6.087.6',
		},
	],
	'Tokenize decimal number with four dots (78.089.6.087.6).',
);

# Test.
$ret_ar = tokenize('330.5+338');
is_deeply(
	$ret_ar,
	[
		{
			'pos' => 0,
			'type' => 'NUMBER',
			'value' => '330.5',
		},
		{
			'pos' => 5,
			'type' => 'OP',
			'value' => '+',
		},
		{
			'pos' => 6,
			'type' => 'NUMBER',
			'value' => '338',
		},
	],
	'Tokenize decimal numbers with + operator (330.5+338).',
);

# Test.
$ret_ar = tokenize('(47+57)');
is_deeply(
	$ret_ar,
	[
		{
			'pos' => 0,
			'type' => 'AUX_GROUP',
			'value' => '(47+57)',
		},
	],
	'Tokenize group ((47+57)).',
);

# Test.
$ret_ar = tokenize('591.5-755.43Abramis brama=20');
is_deeply(
	$ret_ar,
	[
		{
			'pos' => 0,
			'type' => 'NUMBER',
			'value' => '591.5',
		},
		{
			'pos' => 5,
			'type' => 'FORM',
			'value' => '-755.43',
		},
		{
			'pos' => 12,
			'type' => 'ALPHA_SPEC',
			'value' => 'Abramis brama',
		},
		{
			'pos' => 25,
			'type' => 'AUX_LANG',
			'value' => '=20',
		},
	],
	'Tokenize string with valid name (591.5-755.43Abramis brama=20).',
);

# Test.
$ret_ar = tokenize('597.554.3Abramis brama-15=20');
is_deeply(
	$ret_ar,
	[
		{
			'pos' => 0,
			'type' => 'NUMBER',
			'value' => '597.554.3',
		},
		{
			'pos' => 9,
			'type' => 'ALPHA_SPEC',
			'value' => 'Abramis brama',
		},
		{
			'pos' => 22,
			'type' => 'FORM',
			'value' => '-15',
		},
		{
			'pos' => 25,
			'type' => 'AUX_LANG',
			'value' => '=20',
		},
	],
	'Tokenize string with valid name (591.5-755.43Abramis brama=20).',
);

# Test.
$ret_ar = tokenize('004.42 Photo Studio');
is_deeply(
	$ret_ar,
	[
		{
			'pos' => 0,
			'type' => 'NUMBER',
			'value' => '004.42',
		},
		{
			'pos' => 7,
			'type' => 'ALPHA_SPEC',
			'value' => 'Photo Studio',
		},
	],
	'Tokenize string with valid name (004.42 Photo Studio).',
);

# Test.
$ret_ar = tokenize('004.438C++');
is_deeply(
	$ret_ar,
	[
		{
			'pos' => 0,
			'type' => 'NUMBER',
			'value' => '004.438',
		},
		{
			'pos' => 7,
			'type' => 'ALPHA_SPEC',
			'value' => 'C++',
		},
	],
	'Tokenize string with + in name (004.438C++).',
);

# Test.
$ret_ar = tokenize('004.438C#');
is_deeply(
	$ret_ar,
	[
		{
			'pos' => 0,
			'type' => 'NUMBER',
			'value' => '004.438',
		},
		{
			'pos' => 7,
			'type' => 'ALPHA_SPEC',
			'value' => 'C#',
		},
	],
	'Tokenize string with # in name (004.438C#).',
);

# Test.
$ret_ar = tokenize(decode_utf8('populárně-naučné publikace'));
is_deeply(
	$ret_ar,
	[
		{
			'pos' => 0,
			'type' => 'ALPHA_SPEC',
			'value' => decode_utf8('populárně-naučné publikace'),
		},
	],
	'Tokenize bad UDC string, which is ALPHA_SPEC only (populárně-naučné publikace).',
);

# Test.
eval {
	tokenize('78.089 (123)');
};
is($EVAL_ERROR, "Whitespace is not allowed in UDC string.\n",
	"Whitespace is not allowed in UDC string.");
clean();

# Test.
eval {
	tokenize('677.062 +65.01] :687.1(082)');
};
is($EVAL_ERROR, "Whitespace is not allowed in UDC string.\n",
	"Whitespace is not allowed in UDC string.");
clean();
