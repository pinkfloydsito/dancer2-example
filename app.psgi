use Dancer2;
use Dancer2::Plugin::DBIC;

use FindBin;
use lib "$FindBin::Bin/";

use VaultSingleton;
use Data::Dumper;
use Dancer2::DBICConfig;

my $db_config = Dancer2::DBICConfig::get_db_config();

config->{plugins}->{'DBIC'} = $db_config;
set environment => 'development';

get '/' => sub {
    my $dbic_config = config->{plugins};

    debug(config);
    debug($dbic_config);

    return "Hello, World!";
};

start;
