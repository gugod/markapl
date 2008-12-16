package MyTestView;

use Markapl;

template "/foo.html" => sub {
    outs "foo.html output";
};

template "/foo/bar.html" => sub {
    outs "bar.html output";
};


template '/rowcell.html' => sub {
    table {
        row {
            cell { "HI" }
        }
    }
};

1;

