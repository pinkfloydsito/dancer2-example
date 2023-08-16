package MyRedis;

use strict;
use warnings;
use Redis;
use Dancer2;

sub new {
    my ($class, %args) = @_;
    my $self = {
        host => $args{host} || '127.0.0.1',
        port => $args{port} || 6379,
        password => $args{password} || undef,
        redis => undef,
    };
    bless $self, $class;
    $self->_connect();
    return $self;
}

sub _connect {
    my ($self) = @_;
    my %options = (
        server => "$self->{host}:$self->{port}",
        password => $self->{password},
    );

    $self->{redis} = Redis->new(%options);
}

sub get {
    my ($self, $key) = @_;
    return $self->{redis}->get($key);
}

sub set {
    my ($self, $key, $value) = @_;
    return $self->{redis}->set($key, $value);
}

sub delete {
    my ($self, $key) = @_;
    return $self->{redis}->del($key);
}

sub keys {
    my ($self, $pattern) = @_;
    return $self->{redis}->keys($pattern);
}

sub delete_keys_with_substring {
    my ($self, $substring) = @_;
    my @keys_to_delete = $self->{redis}->keys("*$substring*");

    if (@keys_to_delete) {
        return $self->{redis}->del(@keys_to_delete); 
    }
    return 0;
}

1; # End of package

