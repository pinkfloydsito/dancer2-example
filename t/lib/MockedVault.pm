package MockedVault;

use strict;
use warnings;

sub new {
    my ($class, $params) = @_;
    return bless {
        base_url => $params->{base_url},
        token    => $params->{token},
        version  => "V1",
    }, $class;
}

sub token {
    my ($self) = @_;
    return $self->{token};
}

sub version {
    my ($self) = @_;
    return $self->{version};
}

sub base_url {
    my ($self) = @_;
    return $self->{base_url};
}

1;