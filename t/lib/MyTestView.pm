package MyTestView;

use Markapl;

template "/foo.html" => sub {
    outs "foo.html output";
};

template "/foo/bar.html" => sub {
    outs "bar.html output";
};

1;

