use strict;
use warnings;

use Business::UDC;
use Test::More 'tests' => 15;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);

# Test.
my $obj = Business::UDC->new('0/9');
is($obj->error, undef, 'Get error (no error).');

# Test.
$obj = Business::UDC->new('bad');
is($obj->error, "Alphabetical specification cannot appear standalone.",
	'Get error (Alphabetical specification cannot appear standalone.).');
# TODO Check error parameters

# Test.
$obj = Business::UDC->new;
is($obj->error, 'No input provided.', 'No input provided.');

# Test.
$obj = Business::UDC->new('');
is($obj->error, 'Empty input.', 'Empty input.');

# Test.
$obj = Business::UDC->new("811`373");
is($obj->error, 'Bad apostrophe character.', 'Bad apostrophe character (`).');
my ($error, %params) = $obj->error;
is($error, 'Bad apostrophe character.', 'Bad apostrophe character (`).');
is($params{'character'}, '`', 'Bad apostrophe character parameter (`).');
is($params{'position'}, 3, 'Bad apostrophe position parameter (`).');

# Test.
$obj = Business::UDC->new("811&apos;373");
($error, %params) = $obj->error;
is($error, 'Bad apostrophe character.', 'Bad apostrophe character (&apos;).');
is($params{'character'}, '&apos;', 'Bad apostrophe character parameter (&apos;).');
is($params{'position'}, 3, 'Bad apostrophe position parameter (&apos;).');

# Test.
$obj = Business::UDC->new(decode_utf8("811’373"));
($error, %params) = $obj->error;
is($error, 'Bad apostrophe character.', 'Bad apostrophe character (right single quote).');
is($params{'character'}, decode_utf8('’'), 'Bad apostrophe character parameter (right single quote).');
is($params{'position'}, 3, 'Bad apostrophe position parameter (right single quote).');
