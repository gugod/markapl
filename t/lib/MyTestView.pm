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


template '/linklist.html' => sub {
    html {
        head { title { "Test" } };
        body {
            h1 { "Hi" };

            my @link = (
                ["Currency", "/currency"],
                ["Foo", "/foo"],
            );
            ul {
                for my $l (@link) {
                    li {
                        a( href => $l->[1] ) {
                            outs $l->[0];
                        };
                    };
                }
            };

        }
    };
};

1;

