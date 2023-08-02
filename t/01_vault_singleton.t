use warnings;
use Test::More;
use Test::MockModule;
use Test::MockObject;
use Test::More::Behaviour; 

use FindBin qw($Bin);
use lib "$Bin/../"; 

use lib './t/lib';

use WebService::HashiCorp::Vault;

use MockedVault;
use VaultSingleton;

describe 'VaultClient' => sub {
    sub before_all {
        {
            no warnings 'redefine';
            local *WebService::HashiCorp::Vault::new = \&MockedVault::new;
            local *WebService::HashiCorp::Vault::token = \&MockedVault::token;
            local *WebService::HashiCorp::Vault::version = \&MockedVault::version;
            local *WebService::HashiCorp::Vault::base_url = \&MockedVault::base_url;
        };
    };

    context 'when multiple instances try to be created' => sub {
        it 'returns the same reference since it is a singleton' => sub {
            my $instance1 = VaultSingleton->new();
            my $instance2 = VaultSingleton->new();
            is($instance1, $instance2, "Singleton instances are the same");
        };
    };

    context 'when VaultClient instance executes the login method' => sub {
        context 'when vault api does not exist' => sub {
            it 'should instantiate the vault_api object with its attributes' => sub {
                my $vault_url = 'https://vault.example.com';
                my $vault_token = 'test_token';

                my $vault_login = VaultSingleton->new();

                $vault_login->login($vault_url, $vault_token);

                my $vault_api_object = $vault_login->{vault_api};


                is($vault_api_object->base_url(), $vault_url, "Vault API base url");
                is($vault_api_object->version(), "V1", "Vault API version");
                is($vault_api_object->token(), $vault_token, "Vault API auth token is set correctly");
            };
        };

        context 'when vault api already exists' => sub {
            it 'should re-use the previous WebService::HashiCorp::Vault object' => sub {
                my $vault_url = 'https://vault.example.com';
                my $vault_token = 'test_token';

                my $vault_login = VaultSingleton->new();

                $vault_login->login($vault_url, $vault_token);
                my $vault_api_object = $vault_login->{vault_api};

                $vault_login->login($vault_url, $vault_token);
                my $vault_api_object2 = $vault_login->{vault_api};


                is($vault_api_object, $vault_api_object2, "Vault Api objects are the same");
            };
        };
    };

    context 'when VaultClient instance executes the secrets subroutine' => sub {
        it 'returns a hash with the respective keys'  => sub { 
            my $vault_url = 'https://vault.example.com';
            my $vault_token = 'test_token';

            my $vault = VaultSingleton->new();

            my $mock_vault_api = Test::MockObject->new();

            $mock_vault_api->mock(
                'secret',
                sub {
                    my ($self, %args) = @_;
                    my $backend = $args{backend};
                    my $mount = $args{mount};
                    my $path = $args{path};
        
                    my $data = {
                        TEST_KEY   => "test_value",
                        TEST_KEY_2 => "test_value_2"
                    };

                    my $data_sub = sub {
                        return $data;
                    };

                    $self->{data} = $data_sub;

                    bless $self, 'WebService::HashiCorp::Vault::Secret::Generic'
                }
            );

            $params = {
                backend => "kvv2",
                mount => "secret",
                path => "tucows-billing-test"
            };

            $vault->{vault_api} = $mock_vault_api;
            my $result = $vault->secrets($params);


            my $expected_secrets = {
                TEST_KEY      => 'test_value',
                TEST_KEY_2     => 'test_value_2'
            };

            is_deeply(\%result, \%expected_secrets, 'Secrets retrieved match correctly');
        };
    };

    context 'when VaultClient instance executes populate_env_vars subroutine' => sub {
        it 'populates the Env with those values' => sub {

            my $vault = VaultSingleton->new();

            my $env = {
                TEST_KEY   => "test_value",
                TEST_KEY_2 => "test_value_2"
            };

            $vault->populate_env_vars($env);

            is($ENV{TEST_KEY}, 'test_value', 'Environment variable TEST_KEY is set correctly');
            is($ENV{TEST_KEY_2}, 'test_value_2', 'Environment variable TEST_KEY_2 is set correctly');
        };
    };
};

done_testing();
