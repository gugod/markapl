use strict;
use warnings;
use inc::Module::Install;

all_from 'lib/Markapl.pm';

build_requires
    'HTML::Lint'        => 0,
    'Test::HTML::Lint'  => '2.06',
    'Test::More'        => '0.42';

# The list of evil modules
requires
    'B::Hooks::EndOfScope' => 0.05,
    'Devel::Declare' => 0;

# Safer ones
requires
    'HTML::Entities' => 0,
    'Sub::Alias' => 0.02,
    'Exporter::Lite' => 0,
    'Sub::Install' => 0;

WriteAll;

