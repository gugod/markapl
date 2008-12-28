use strict;
use warnings;
use inc::Module::Install;

all_from 'lib/Markapl.pm';

build_requires  'Test::More'        => '0.42';

# The list of evil modules
requires
    'B::Hooks::EndOfScope' => 0,
    'Devel::Declare' => 0;

# Safer ones
requires
    'Sub::Alias' => 0.02,
    'Exporter::Lite' => 0,
    'Sub::Install' => 0;

WriteAll;


