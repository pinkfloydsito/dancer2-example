package Dancer2::DBICConfig;

use strict;
use warnings;

sub get_db_config {
    my $vault_url = 'http://vault:8200';
    my $vault_token = 'root-token';

    my $vault_client = VaultSingleton->new();

    $vault_client->login($vault_url, $vault_token);

    my $params = {
        backend => "kvv2",
        mount => "kv",
        path => "billing"
    };

    my $secrets = $vault_client->secrets($params);

    $vault_client->populate_env_vars($secrets);

    my $db_name     = $ENV{DBNAME}     || "";
    my $db_host     = $ENV{DBHOST}     || "";
    my $db_username = $ENV{DBUSER} || "";
    my $db_password = $ENV{DBPASS} || "";
    my $db_port     = $ENV{DBPORT}     || "";

    my $dsn = "dbi:Pg:dbname=$db_name";
    $dsn .= ";host=$db_host" if $db_host;
    $dsn .= ";port=$db_port" if $db_port;

    my $db_config = {
        billing => {
            dsn      => $dsn,
            user     => $db_username,
            password => $db_password,
        }
    };

    return $db_config;
}

1;