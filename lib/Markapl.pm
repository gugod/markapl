package Markapl;
use strict;
use warnings;
use Devel::Declare ();
use Sub::Install qw(install_sub);

use 5.008;
our $VERSION = "0.03";

use Markapl::TagHandlers;

use Markapl::Buffer;
my @buffer_stack;

sub new_buffer_frame {
    my $buf = Markapl::Buffer->new(data => '');
    unshift @buffer_stack, $buf;
}

sub end_buffer_frame {
    shift @buffer_stack;
}

sub buffer {
    $buffer_stack[0];
}

sub template {
    my ($name, $code) = @_;
    my $caller = caller;
    install_sub({
        code => $code,
        into => $caller,
        as => $name
    });
}

sub outs($) {
    my $str = shift;
    Markapl->buffer->append( $str );
    return "";
}

sub render {
    my ($self, $template) = @_;

    Markapl->new_buffer_frame;
    if (my $sub = $self->can($template)) {
        $sub->($self);
    }
    return Markapl->end_buffer_frame->data;
}

sub _get_tag_list {
    return qw(
        h1 h2 h3 h4 h5 h6 p br hr ol ul li dl dt dd menu code var strong em tt
        u i b blockquote pre img a address cite samp dfn html head body
        link nextid title meta kbd start_html end_html input select option
        comment charset escapehtml div table caption th sup sub
        strike applet param nobr embed basefont style span layer ilayer font
        frameset frame script small big area map abbr acronym bdo col colgroup
        del fieldset iframe ins label legend noframes noscript object optgroup
        q thead tbody tfoot blink fontsize center textfield textarea filefield
        password_field hidden checkbox checkbox_group submit reset defaults
        radio_group popup_menu button autoescape scrolling_list image_button
        start_form end_form startform endform start_multipart_form
        end_multipart_form isindex tmpfilename uploadinfo url_encoded
        multipart form canvas
        row cell
    )
}

sub import {
    my ($class) = @_;
    my $caller = caller;

    {
        no strict;
        *{"${caller}::render"} = \&render;
        *{"${caller}::outs"} = \&outs;
        *{"${caller}::template"} = \&template;
    }

    my $config = {};
    my $code_str = qq{package $caller;};

    for my $tag (&_get_tag_list) {
        $code_str .= qq{sub $tag (&);};
        $config->{$tag} = {
            const => Markapl::TagHandlers::tag_parser_for($tag)
        }
    }

    eval $code_str;
    Devel::Declare->setup_for($caller, $config);
}

1;
__END__

=head1 NAME

Markapl - Markup as Perl

=head1 VERSION

This document describes Markapl version 0.03

=head1 SYNOPSIS

    package MyView;
    use Markapl;

    tempalte '/a/page.html' => sub {
        h1("#title") { "Hi" };
        p(".first") { "In the begining, lorem ipsum...." };
        p(style => "color: red;") { "But...." };
    }

    package main;
    my $output = MyView->render("/a/page.html");

=head1 TUTORIAL

Here's a short guide how to use this module. You can skip this
tutorial section if you're already using L<Template::Declare>, since
it's exactly the same.

First of all, you need a sole package for defining your tempaltes,
let's call it "MyView" in the example.  Then you C<use Markapl> (but
not use base), then your view package will be installed many
subroutines automatically:

    package MyView;
    use Markapl;

To define a template, use C<template> function like this:

    tempalte '/page.html' => sub {
        h1("#title") { "Hi" };
        p(".first") { "In the begining, lorem ipsum...." };
        p(style => "color: red;") { "But...." };
    }

To render it, call C<render> function:

    my $out = MyView->render("/page.html");

Besides these two functions, C<Markapl> also exports about another 120
tag functions that are named after HTML tags, for exapmle, h1, h2, h3,
div, p, and span. Almost all HTML tags are defined as a function.

In your template, if you say:

    h1 { "Hi" };

It'll be rendered as:

    <h1>Hi</h1>

The block after C<h1> is an anonymous sub-routine, and the return
value of which will become the content of the C<h1> tag.

If you want to add attributes to the tag, do it like this:

    div(id => "example", class => "lipsum") { "Lorem ipsum" };

Alternatively, you can use CSS selector syntax to quickly defined
id and class attribute:

    div("#example") { "Lorem ipsum" };

That only works when the attribute list contain excatly one string inside.

A special function C<outs> need to be used to concatinate strings with
inline elements:

    p {
        outs "Hello, ";
        a(href => "/users/gugod") { "gugod" };
    }

=head1 DESCRIPTION

This is a new try to use L<Devel::Declare> to change the Perl5
language. It learns pretty much everything from L<Tempalte::Declare>,
and has similar interface. With only one difference: how element
attributes are defined.

In L<Template::Declare>, it goes like:

    h1 {
        id is "title";
        outs "Hi";
    };

In here, it is:

    h1(id => "title") { "Hi" };

Or a shorthand for "id" attribute:

    h1("#title") { "Hi" };

=head1 INTERFACE 

=over

=item template($name, $code);

Defines a template.

=item render($name)

You need to call it as class method like,

   MyView->render("/foo.html");

Or

   render MyView, "/foo.html";

If you happen to like this style.

Doesn't support tempalte variable yet. Stay tuned.

=item outs($str);

Should be used in side a template body. It appends C<$str> to current
output buffer frame.

=back

=head1 DEPENDENCIES

C<Devel::Declare>

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-markapl@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Kang-min Liu  C<< <gugod@gugod.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, Kang-min Liu C<< <gugod@gugod.org> >>.

This is free software, licensed under:

    The MIT (X11) License

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
