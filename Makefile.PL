use strict;
use warnings;
use inc::Module::Install;

all_from 'lib/Markapl.pm';

build_requires  'Test::More'        => '0.42';

# The list of evil modules
requires
    'Devel::Caller' => 0,
    'PadWalker' => 0,
    'Devel::Declare' => 0;

# Safer ones
requires
    'Sub::Install' => 0,
    'Data::Dump' => 0;

WriteAll;


