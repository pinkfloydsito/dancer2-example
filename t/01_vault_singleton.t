use warnings;
use Test::More;
use Test::MockModule;

use FindBin qw($Bin);
use lib "$Bin/../"; 

use WebService::HashiCorp::Vault;

use VaultSingleton;


subtest 'Test VaultSingleton' => sub {
    plan tests => 4;

    my $mock_vault_api = {
        base_url => undef,
        token    => undef,
        version  => 1,

        new => sub {
            my ($class, $params) = @_;
            return bless {
                base_url => $params->{base_url},
                token    => $params->{token},
                version  => "V1",
            }, $class;
        },

        token => sub {
            my ($self) = @_;
            return $self->{token};
        },

        version => sub {
            my ($self) = @_;
            return $self->{version};
        },

        base_url => sub {
            my ($self) = @_;
            return $self->{base_url};
        },
    };

    {
        no warnings 'redefine';
        local *WebService::HashiCorp::Vault::new = $mock_vault_api->{new};
        local *WebService::HashiCorp::Vault::token = $mock_vault_api->{token};
        local *WebService::HashiCorp::Vault::version = $mock_vault_api->{version};
        local *WebService::HashiCorp::Vault::base_url = $mock_vault_api->{base_url};
    }

    my $vault_url = 'https://vault.example.com';
    my $vault_token = 'test_token';

    my $instance1 = VaultSingleton->new();
    my $instance2 = VaultSingleton->new();
    is($instance1, $instance2, "Singleton instances are the same");

    my $vault_login = VaultSingleton->new();

    $vault_login->login($vault_url, $vault_token);

    my $vault_api_object = $vault_login->{vault_api};


    is($vault_api_object->base_url(), $vault_url, "Vault API base url");
    is($vault_api_object->version(), "V1", "Vault API version");
    is($vault_api_object->token(), $vault_token, "Vault API auth token is set correctly");

};

subtest 'Test VaultSingleton_GetSecret' => sub {
    plan tests => 4;

    my $mock_vault_api = {
        base_url => undef,
        token    => undef,
        version  => 1,

        new => sub {
            my ($class, $params) = @_;
            return bless {
                base_url => $params->{base_url},
                token    => $params->{token},
                version  => "V1",
            }, $class;
        },

        token => sub {
            my ($self) = @_;
            return $self->{token};
        },

        version => sub {
            my ($self) = @_;
            return $self->{version};
        },

        base_url => sub {
            my ($self) = @_;
            return $self->{base_url};
        },
    };

    {
        no warnings 'redefine';
        local *WebService::HashiCorp::Vault::new = $mock_vault_api->{new};
        local *WebService::HashiCorp::Vault::token = $mock_vault_api->{token};
        local *WebService::HashiCorp::Vault::version = $mock_vault_api->{version};
        local *WebService::HashiCorp::Vault::base_url = $mock_vault_api->{base_url};
    }

    my $vault_url = 'https://vault.example.com';
    my $vault_token = 'test_token';

    my $instance1 = VaultSingleton->new();
    my $instance2 = VaultSingleton->new();
    is($instance1, $instance2, "Singleton instances are the same");

    my $vault_login = VaultSingleton->new();

    $vault_login->login($vault_url, $vault_token);

    my $vault_api_object = $vault_login->{vault_api};


    is($vault_api_object->base_url(), $vault_url, "Vault API base url");
    is($vault_api_object->version(), "V1", "Vault API version");
    is($vault_api_object->token(), $vault_token, "Vault API auth token is set correctly");

};
done_testing();
