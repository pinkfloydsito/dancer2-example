use Dancer2;

use FindBin;
use lib "$FindBin::Bin/";

use VaultSingleton;
use Data::Dumper;

get '/' => sub {
    my $vault_url = 'http://vault:8200';
    my $vault_token = 'root-token';

    my $vault_client = VaultSingleton->new();

    $vault_client->login($vault_url, $vault_token);

    my $params = {
        backend => "kvv2",
        mount => "kv",
        path => "tucows-billing"
    };

    my $result = $vault_client->secrets($params);
    my $hash_dump = Dumper($result);

    debug($hash_dump);

    return "Hello, World!";
};

start;
