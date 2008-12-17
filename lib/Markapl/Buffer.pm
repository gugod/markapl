package Markapl::Buffer;
use strict;
use warnings;

our $VERSION = '0.02';

sub new {
    my $class = shift;
    my $self = { data => '' };
    bless $self, $class;
}

sub data {
    my ($self, $new_data) = @_;
    return $self->{data} unless defined $new_data;
    $self->{data} = $new_data;
}

sub append {
    my ($self, $data) = @_;
    $self->{data} = ($self->data||'') . ($data||'');
    return $self;
}

sub clear {
    my $self = shift;
    $self->{data} = '';
}

1;

