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

sub linklist {
    my @link = @_;
    ul {
        for my $l (@link) {
            li {
                a( href => $l->[1] ) { $l->[0] }
            };
        }
    };
}

template '/linklist.html' => sub {
    html {
        head { title { "Test" } };
        body {
            h1 { "Hi" };

            linklist(
                ["Currency", "/currency"],
                ["Foo", "/foo"],
            );

        }
    };
};

1;

