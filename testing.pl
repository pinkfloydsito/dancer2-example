#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use Data::Dumper;

$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = 1;

use WebService::HashiCorp::Vault;

my $TOKEN = "root-token" ;

die "Please set your root token" if ! $TOKEN;

my $vault = WebService::HashiCorp::Vault->new(
    token => $TOKEN,
    base_url => "http://vault:8200"
    );

die "Couldn't open vault" if !$vault;

# Grab or prepare to instantiate a secret 'path'
my $secrets_test = $vault->secret( backend => 'kvv2', path => 'tucows-billing' );

# Examine the data
my $data = $secrets_test->data();

# Save the data in to the secret
#$secrets_test->data({
#   test => '1234'
#   });

#Obtener secretos;

 $data = {
        vault => $vault,
        backend => 'kvv2',
        mount => 'kv',
        path => "tucows-billing"
    };

p getSecrets($data);

sub getSecrets {
    my ($params) = @_;

    my $vault = $params->{vault};
    my $backend = $params->{backend};
    my $mount = $params->{mount};
    my $path = $params->{path};

    my $list = $vault->secret( backend => $backend, mount => $mount, path => $path );
    my $data = $list->data();
    
    return $data;
}