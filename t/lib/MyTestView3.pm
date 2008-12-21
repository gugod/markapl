package MyTestView3;

use Markapl;

template "/var1.html" => sub {
    my ($self, %vars) = @_;
    h1(".title") { outs $vars{title} };
};


1;
