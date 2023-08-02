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

    my $vault_api = WebService::HashiCorp::Vault->new(
        base_url => $vault_url,
        token => $token,
        version => "V1"
        );

    $self->{vault_api} = $vault_api;
}

sub getSecrets {
    my ($self, $params) = @_;

    my $vault = $self->{vault_api}
    my $backend = $params->{backend};
    my $mount = $params->{mount};
    my $path = $params->{path};

    my $list = $vault->secret( backend => $backend, mount => $mount, path => $path );
    my $data = $list->data();
    
    return $data;
}

1;