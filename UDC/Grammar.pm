package Business::UDC::Grammar;

use base qw(Exporter);
use strict;
use warnings;

use List::Util 1.33 qw(any);
use Readonly;

Readonly::Array our @EXPORT_OK => qw(can_be_standalone can_follow_operator
	can_follow_primary can_follow_term can_precede_number
	can_start_expression_with describe_token_type group_subtype is_modifier_token
	is_operator_token is_primary_token is_valid_operator operator_info);
Readonly::Hash our %DESC => (
	NUMBER => 'main UDC number',
	PARTIAL_NUMBER => 'partial number for range shorthand',
	AUX_GROUP => 'parenthesized auxiliary',
	AUX_TIME => 'quoted time auxiliary',
	AUX_LANG => 'language auxiliary',
	FORM => 'special auxiliary subdivision',
	OP => 'operator',
);
Readonly::Hash our %TOKEN_RULES => (
	AUX_GROUP => {
		standalone => 1,
		primary => 1,
		modifier => 1,
	},
	AUX_LANG => {
		standalone => 1,
		primary => 1,
		modifier => 1,
	},
	AUX_TIME => {
		standalone => 1,
		primary => 1,
		modifier => 1,
	},
	FORM => {
		standalone => 0,
		primary => 0,
		modifier => 1,
	},
	NUMBER => {
		standalone => 1,
		primary => 1,
		modifier => 0,
	},
	OP => {
		standalone => 0,
		primary => 0,
		modifier => 0,
	},
	PARTIAL_NUMBER => {
		standalone => 0,
		primary => 0,
		modifier => 0,
	},
);
Readonly::Hash our %OPERATORS => (
	'+' => {
		name => 'addition',
		precedence => 10,
		associativity => 'left',
		right_types => [qw(NUMBER AUX_GROUP AUX_TIME AUX_LANG)],
	},
	':' => {
		name => 'relation',
		precedence => 20,
		associativity => 'left',
		right_types => [qw(NUMBER AUX_GROUP AUX_TIME AUX_LANG)],
	},
	'/' => {
		name => 'consecutive_extension',
		precedence => 15,
		associativity => 'left',
		right_types => [qw(NUMBER PARTIAL_NUMBER AUX_GROUP AUX_TIME AUX_LANG)],
	},
);

our $VERSION = 0.01;

sub can_be_standalone {
	my $type = shift;

	if (! $TOKEN_RULES{$type}) {
		return 0;
	}

	if ($type eq 'AUX_GROUP') {
		return 1;
	}

	return $TOKEN_RULES{$type}{'standalone'} ? 1 : 0;
}

sub can_follow_operator {
	my ($op, $type) = @_;

	if (! is_valid_operator($op)) {
		return 0;
	}

	my %allowed = map { $_ => 1 } @{$OPERATORS{$op}{'right_types'} || []};

	return $allowed{$type} ? 1 : 0;
}

sub can_follow_primary {
	my ($type, $value, $primary_type) = @_;

	if (! is_modifier_token($type)) {
		return 0;
	}

	if ($type eq 'FORM') {
		if (defined $primary_type
			&& any { $primary_type eq $_ } qw(NUMBER AUX_GROUP AUX_LANG AUX_TIME)) {

			return 1;
		}
		return 0;
	} elsif ($type eq 'AUX_GROUP') {
		my $subtype = group_subtype($value);
		if ($subtype eq 'AUX_FORM') {
			return 1;
		}

		# XXX
		return 1;
	} elsif ($type eq 'AUX_TIME') {
		return 1;
	} elsif ($type eq 'AUX_LANG') {
		return 1;
	}

	return 0;
}

sub can_follow_term {
	my $type = shift;

	return is_operator_token($type);
}

sub can_precede_number {
	my ($type, $value) = @_;

	return 0 unless defined $type;

	if ($type eq 'AUX_GROUP') {
		my $subtype = group_subtype($value);
		return $subtype eq 'AUX_FORM' ? 1 : 0;
	}

	if ($type eq 'AUX_TIME' || $type eq 'AUX_LANG') {
		return 0;
	}

	return 0;
}

sub can_start_expression_with {
	my $type = shift;

	return can_be_standalone($type);
}

sub describe_token_type {
	my $type = shift;

	return $DESC{$type} || 'unknown token';
}

sub group_subtype {
	my $value = shift;

	if (! defined $value) {
		return 'UNKNOWN';
	}

	# Common auxiliaries of form: (0...)
	return 'AUX_FORM' if $value =~ /^\(0(?:[^)]*)\)$/;

	# Place and other special auxiliaries typically begin with non-zero digit
	return 'AUX_OTHER' if $value =~ /^\([1-9][^)]*\)$/;

	return 'UNKNOWN';
}

sub is_modifier_token {
	my $type = shift;

	return ($TOKEN_RULES{$type} && $TOKEN_RULES{$type}{'modifier'}) ? 1 : 0;
}

sub is_operator_token {
	my $type = shift;

	return (defined $type && $type eq 'OP') ? 1 : 0;
}

sub is_primary_token {
	my $type = shift;

	return ($TOKEN_RULES{$type} && $TOKEN_RULES{$type}{'primary'}) ? 1 : 0;
}

sub is_valid_operator {
	my $op = shift;

	return exists $OPERATORS{$op} ? 1 : 0;
}

sub operator_info {
	my $op = shift;

	return $OPERATORS{$op};
}

1;

__END__
