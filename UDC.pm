package Business::UDC;

use strict;
use warnings;

use Business::UDC::Parser qw(parse);
use English;
use Error::Pure::Utils qw(clean);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, $source) = @_;

	# Create object.
	my $self = bless {
		'source' => $source,
		'_ast' => undef,
		'_error' => undef,
		'_tokens' => [],
		'_valid' => 0,
	}, $class;

	my $res_hr = eval {
		parse($self->{'source'});
	};
	if ($EVAL_ERROR) {
		chomp $EVAL_ERROR;
		$self->{'_error'} = $EVAL_ERROR;
		clean();
	} else {
		$self->{'_ast'} = $res_hr->{'ast'};
		$self->{'_tokens'} = $res_hr->{'tokens'};
		$self->{'_valid'} = 1;
	}

	return $self;
}

sub ast {
	my $self = shift;

	return $self->{'_ast'};
}

sub error {
	my $self = shift;

	return $self->{'_error'};
}

sub is_valid {
	my $self = shift;

	return $self->{'_valid'};
}

sub source {
	my $self = shift;

	return $self->{'source'};
}

sub tokens {
	my $self = shift;

	return $self->{'_tokens'};
}

1;

__END__
