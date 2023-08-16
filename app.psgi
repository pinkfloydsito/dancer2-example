use Dancer2;
use Dancer2::Plugin::DBIC;

use FindBin;
use lib "$FindBin::Bin/";

use VaultSingleton;
use MyRedis;
use Data::Dumper;
use Dancer2::DBICConfig;

my $db_config = Dancer2::DBICConfig::get_db_config();

config->{plugins}->{'DBIC'} = $db_config;
set environment => 'development';

get '/' => sub {
    my $dbic_config = config->{plugins};

    debug(config);
    debug($dbic_config);

    my $redis = MyRedis->new(host => 'redis', port => 6379);

    # Set a key-value pair
    $redis->set('ip_jorgito_test1', '1.1.1.1');
    $redis->set('ip_jorgito_test2', '0.0.1.1');

    # Get the value for a key
    my $value = $redis->get('my_key');
    debug "Value: $value\n";

    # Delete a key
    #$redis->delete_keys_with_substring1('jorgito');
    my $cursor = '0';
    my @keys_to_delete;
    while (1) {
        my ($next_cursor, @matching_keys) = $redis->{redis}->scan($cursor, MATCH => "*jorgito*");

        push @keys_to_delete, @matching_keys;

        last if $next_cursor eq '0';

        $cursor = $next_cursor;
    }

    if (@keys_to_delete) {
        debug @keys_to_delete;
        $redis->{redis}->del(@keys_to_delete);
    }
    # Get all keys matching a pattern
    my @keys = $redis->keys('some_pattern*');
    debug "Matching keys: @keys\n";

    return "Hello World!!";

};



start;
