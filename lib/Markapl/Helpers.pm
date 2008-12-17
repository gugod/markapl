package Markapl::Helpers;
use strict;
use Markapl;

use Exporter::Lite;
our @EXPORT = qw(THs TDs ths tds heads cells);

sub heads {
    for (@_) { th { $_ } }
}

sub cells {
    for (@_) { cell { $_ } }
}

{
    no strict;
    no warnings;

    *THs = \&heads;
    *ths = \&heads;
    *TDs = \&cells;
    *tds = \&cells; 
}



1;
