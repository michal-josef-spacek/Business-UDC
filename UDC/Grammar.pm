package Business::UDC::Grammar;

use base qw(Exporter);
use strict;
use warnings;

use Readonly;

Readonly::Array our @EXPORT_OK => qw(can_be_standalone can_follow_primary can_follow_term
	can_start_expression_with can_follow_term describe_token_type
	is_modifier_token is_operator_token is_primary_token is_valid_operator
	operator_info);
Readonly::Hash our %DESC => (
	NUMBER => 'main UDC number',
	AUX_GROUP => 'parenthesized auxiliary',
	AUX_TIME => 'quoted time auxiliary',
	AUX_LANG => 'language auxiliary',
	FORM => 'special auxiliary subdivision',
	OP => 'operator',
);
Readonly::Hash our %TOKEN_KINDS => (
	NUMBER => 'primary',
	AUX_GROUP => 'primary_or_modifier',
	AUX_TIME => 'primary_or_modifier',
	AUX_LANG => 'primary_or_modifier',
	FORM => 'modifier_only',
	OP => 'operator',
);
Readonly::Hash our %OPERATORS => (
	'+' => {
		name => 'addition',
		precedence => 10,
		associativity => 'left',
	},
	':' => {
		name => 'relation',
		precedence => 20,
		associativity => 'left',
	},
	'/' => {
		name => 'consecutive_extension',
		precedence => 15,
		associativity => 'left',
	},
);

our $VERSION = 0.01;

sub can_be_standalone {
	my $type = shift;

	return is_primary_token($type);
}

sub can_follow_primary {
	my $type = shift;

	return is_modifier_token($type);
}

sub can_follow_term {
	my $type = shift;

	return is_operator_token($type);
}

sub can_start_expression_with {
	my $type = shift;

	return can_be_standalone($type);
}

sub describe_token_type {
	my $type = shift;

	return $DESC{$type} || 'unknown token';
}

sub is_modifier_token {
	my $type = shift;

	my $k = $TOKEN_KINDS{$type};

	return defined $k && ($k eq 'modifier_only' || $k eq 'primary_or_modifier') ? 1 : 0;
}

sub is_operator_token {
	my $type = shift;

	return $type eq 'OP' ? 1 : 0;
}

sub is_primary_token {
	my $type = shift;

	my $k = $TOKEN_KINDS{$type};

	return defined $k && ($k eq 'primary' || $k eq 'primary_or_modifier') ? 1 : 0;
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
