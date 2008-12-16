package Markapl::Buffer;
use strict;
use warnings;

use Object::Tiny qw{data};

sub append {
    my ($self, $data) = @_;
    $self->{data} = ($self->data||'') . ($data||'');
    return $self;
}

sub clear {
    my $self = shift;
    $self->data('');
}

1;

