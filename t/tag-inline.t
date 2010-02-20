#!/usr/bin/env perl -w
use strict;

package View;
use Markapl;

template hr => sub {
    hr;
};

template img => sub {
    img(src => "/one.jpg");
};

template meta => sub {
    meta(content => "text/html", "http-equiv" => "content-type");
};

template input => sub {
    input(type => "text", name => "foo");
};

package main;
use Test::More tests => 4;

is(View->render("hr"), qq{<hr>});
is(View->render("img"), qq{<img src="/one.jpg">});
is(View->render("meta"), qq{<meta content="text/html" http-equiv="content-type">});
is(View->render("input"), qq{<input type="text" name="foo">});
