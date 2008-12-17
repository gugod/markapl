#!perl

use lib 't/lib';

use strict;
use warnings;
use Test::More tests => 6;

use MyTestView2;

for my $name (qw/heads-cells THs-TDs ths-tds/) {
    my $out = MyTestView2->render("/table/helper-${name}");

    like($out, qr/<th>(.+)<\/th>/,  "TH helper works" );
    like($out, qr/<td>(.+)<\/td>/,  "TD helper works" );
}

