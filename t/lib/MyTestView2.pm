package MyTestView2;
use strict;
use warnings;

use Markapl;
use Markapl::Helpers;

template '/helper-heads-cells' => sub {
    table {
	row { heads qw(Name Age Weight Height) };
	row { cells qw(Gugod 29 100kg 170cm)   };
    }
};

template '/helper-THs-TDs' => sub {
    table {
	row { THs qw(Name Age Weight Height) };
	row { TDs qw(Gugod 29 100kg 170cm)   };
    }
};

template '/helper-ths-tds' => sub {
    table {
	row { ths qw(Name Age Weight Height) };
	row { tds qw(Gugod 29 100kg 170cm)   };
    }
};

1;
