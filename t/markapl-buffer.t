#!/usr/bin/env perl -w
use strict;
use Test::More tests => 3;
use Markapl::Buffer;

my $buf = Markapl::Buffer->new(out_method => sub { join("", @_) });
$buf->append("foo");

is( $buf->output_buffer, "foo", "Markapl::Buffer->append" );

$buf->append("bar");
is( $buf->output_buffer, "foobar", "Markapl::Buffer->append" );

$buf->flush_output;
is( $buf->output_buffer, "", "Markapl::Buffer->clear" );
