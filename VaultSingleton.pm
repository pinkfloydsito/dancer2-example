package VaultSingleton;

use strict;
use warnings;
use WebService::HashiCorp::Vault;

my $instance;

sub new {
    my $class = shift;
    return $instance if $instance;
    $instance = bless {}, $class;
    return $instance;
}

sub login {
    my ($self, $vault_url, $token) = @_;

    if (defined $self->{vault_api}) {
        return;
    }

    my $vault_api = WebService::HashiCorp::Vault->new(
        base_url => $vault_url,
        token => $token
        );

    $self->{vault_api} = $vault_api;
}

sub secrets {
    my ($self, $params) = @_;

    my $backend = $params->{backend};
    my $mount = $params->{mount};
    my $path = $params->{path};

    my $list = $self->{vault_api}->secret( backend => $backend, mount => $mount, path => $path );

    my $data = $list->data();
    
    return $data;
}

sub populate_env_vars {
    my ($self, $hash) = @_;
    while (my ($key, $value) = each %$hash) {
        $ENV{$key} = $value;
    }
}

1;