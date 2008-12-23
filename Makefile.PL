use strict;
use warnings;
use inc::Module::Install;

all_from 'lib/Markapl.pm';

build_requires  'Test::More'        => '0.42';

# The list of evil modules
requires
    'Devel::Declare' => 0;

# Safer ones
requires
    'Exporter::Lite' => 0,
    'Sub::Install' => 0;

WriteAll;


