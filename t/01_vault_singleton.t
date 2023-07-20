use strict;
use warnings;
use Test::More;

use FindBin qw($Bin);
use lib "$Bin/../"; 

use WebService::HashiCorp::Vault;

use VaultSingleton;

subtest 'Test VaultSingleton' => sub {
    plan tests => 4;

    my $vault_url = 'https://vault.example.com';
    my $vault_token = 'your_vault_token';

    my $instance1 = VaultSingleton->new();
    my $instance2 = VaultSingleton->new();
    is($instance1, $instance2, "Singleton instances are the same");

    my $vault_login = VaultSingleton->new();
    my $mock_vault_api = mock_vault_api();
    $vault_login->login($vault_url, $vault_token);
    ok($mock_vault_api->{authenticated}, "Vault API is authenticated");
    is($mock_vault_api->{endpoint}, $vault_url, "Vault API endpoint is set correctly");
    is($mock_vault_api->{auth_token}, $vault_token, "Vault API auth token is set correctly");
};

sub mock_vault_api {
    return {
        authenticated => 1,
        endpoint      => undef,
        auth_token    => undef,
        new           => sub {
            my ($class, $params) = @_;
            my $self = bless {}, $class;
            $self->{endpoint} = $params->{endpoint};
            return $self;
        },
        auth_token => sub {
            my ($self, $token) = @_;
            $self->{auth_token} = $token;
        },
    };
}

done_testing();