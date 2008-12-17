#!/usr/bin/env perl -w
use strict;
use Test::More tests => 3;
use Markapl::Buffer;

my $buf = Markapl::Buffer->new;
$buf->append("foo");

is( $buf->data, "foo", "Markapl::Buffer->append" );

$buf->append("bar");
is( $buf->data, "foobar", "Markapl::Buffer->append" );

$buf->clear;
is( $buf->data, "", "Markapl::Buffer->clear" );
