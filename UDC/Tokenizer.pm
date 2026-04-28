package Business::UDC::Tokenizer;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;

Readonly::Array our @EXPORT_OK => qw(tokenize);

our $VERSION = 0.05;

sub tokenize {
	my ($input) = @_;
	my @tokens;

	pos($input) = 0;

	while (pos($input) < length($input)) {
		my $start = pos($input);

		if ($input =~ /\G(\s)/gc) {
			err "Whitespace is not allowed in UDC string.",
				'position' => $start,
				'character' => $1,
			;
		}

		if ($input =~ /\G(\d+(?:\.\d+)*)/gc) {
			_push_token(\@tokens, 'NUMBER', $1, $start);
			next;
		}

		if ($input =~ /\G(\.\d+(?:\.\d+)*)/gc) {
			_push_token(\@tokens, 'AUX_DOT', $1, $start);
			next;
		}

		if ($input =~ /\G(\[)/gc) {
			_push_token(\@tokens, 'LBRACK', $1, $start);
			next;
		}

		if ($input =~ /\G(\])/gc) {
			_push_token(\@tokens, 'RBRACK', $1, $start);
			next;
		}

		if ($input =~ /\G([:+\/])/gc) {
			_push_token(\@tokens, 'OP', $1, $start);
			next;
		}

		if ($input =~ /\G(-\d+(?:\.\d+)*)/gc) {
			_push_token(\@tokens, 'FORM', $1, $start);
			next;
		}

		if ($input =~ /\G(\([^)]+\))/gc) {
			_push_token(\@tokens, 'AUX_GROUP', $1, $start);
			next;
		}

		if ($input =~ /\G("[^"]*")/gc) {
			_push_token(\@tokens, 'AUX_TIME', $1, $start);
			next;
		}

		if ($input =~ /\G(=+(?:[A-Za-z]+|\d+(?:\.\d+)*))/gc) {
			_push_token(\@tokens, 'AUX_LANG', $1, $start);
			next;
		}

		if ($input =~ /\G(\p{L}[\p{L}\p{N}._-]*)/gcu) {
			_push_token(\@tokens, 'ALPHA_SPEC', $1, $start);
			next;
		}

		if ($input =~ /\G(\'\d+(?:\.\d+)*)/gc) {
			_push_token(\@tokens, 'APOS_AUX', $1, $start);
			next;
		}

		my $bad = substr($input, $start, 20);
		err "Unrecognized input near '$bad'.",
			'position' => $start,
		;
	}

	return \@tokens;
}

sub _check_whitespace {
	my ($value, $start) = @_;

	if ($value =~ /^(.*?)\s/s) {
		my $ws_pos = length($1);
		my $char = substr($value, $ws_pos, 1);
		err "Whitespace is not allowed in UDC string.",
			'position' => $start + $ws_pos,
			'character' => $char,
		;
	}

	return;
}

sub _push_token {
	my ($tokens_ar, $type, $value, $start) = @_;

	_check_whitespace($value, $start);

	push @{$tokens_ar}, {
		type => $type,
		value => $value,
		pos => $start,
	};

	return;
}


1;

__END__
