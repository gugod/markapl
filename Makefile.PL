use strict;
use warnings;
use inc::Module::Install;

all_from 'lib/Markapl.pm';

build_requires  'Test::More'        => '0.42';
requiers
    'Devel::Declare' => 0,
    'Data::Dump' => 0;

WriteAll;


