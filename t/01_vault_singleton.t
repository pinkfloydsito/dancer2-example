use warnings;
use Test::More;
use Test::MockModule;

use FindBin qw($Bin);
use lib "$Bin/../"; 

use WebService::HashiCorp::Vault;

use VaultSingleton;

sub mock_vault_api {
    my $class = 'WebService::HashiCorp::Vault';
    my $mock_vault_api = Test::MockModule->new($class);

    # Mock the new method to return a blessed reference
    $mock_vault_api->mock('new', sub { 
        my ($class, $params) = @_;
        return bless {
                base_url => $params->(base_url),
                token => $params->(token),
                version => $params->(version)
    }, $class; });

    # Mock the auth_token method to do nothing or return a mock value
    $mock_vault_api->mock('auth_token', sub { return $_[1]; });

    # Add other mock methods as needed

    return $mock_vault_api;
}

subtest 'Test VaultSingleton' => sub {
    plan tests => 1;

    my $mock_vault_api = {
        new => sub {
            my ($class, $params) = @_;
            return bless {
                base_url => $params->(base_url),
                token => $params->(token),
                version => $params->(version)
            }, $class;
        },
        token => sub {
            my ($self, $value) = @_;

            if (@_ == 2) {
                $self->{token} = $value;
            }

            return $self->{token};
        }
    };

    my $vault_url = 'https://vault.example.com';
    my $vault_token = 'your_vault_token';

    my $instance1 = VaultSingleton->new();
    my $instance2 = VaultSingleton->new();
    is($instance1, $instance2, "Singleton instances are the same");

    {
    no warnings 'redefine';
        local *WebService::HashiCorp::Vault::new = sub {
            my ($class, $params) = @_;
            return $mock_vault_api->new($params);
        };
    }

    my $vault_login = VaultSingleton->new();
    $vault_login->login($vault_url, $vault_token);
    # is($mock_vault_api->version(), "V1", "Vault current version");
    # is($mock_vault_api->base_url(), $vault_url, "Vault API endpoint is set correctly");
    is($mock_vault_api->token(), $vault_token, "Vault API auth token is set correctly");
};


done_testing();