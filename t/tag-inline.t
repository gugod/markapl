#!/usr/bin/env perl -w
use strict;

package View;
use Markapl;

template hr => sub {
    hr;
};

template br => sub {
    br;
};

template img => sub {
    img(src => "/one.jpg");
};

template meta => sub {
    meta(content => "text/html", "http-equiv" => "content-type");
};

template html_link => sub {
    html_link(rel=>'stylesheet', href=>'/style.css');
};

template input => sub {
    input(type => "text", name => "foo");
};

package main;
use Test::More tests => 6;

is(View->render("hr"), qq{<hr>});
is(View->render("br"), qq{<br>});
is(View->render("img"), qq{<img src="/one.jpg">});
is(View->render("meta"), qq{<meta content="text/html" http-equiv="content-type">});
is(View->render("html_link"), qq{<link rel="stylesheet" href="/style.css">});
is(View->render("input"), qq{<input type="text" name="foo">});
