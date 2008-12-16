package Markapl;
use strict;
use warnings;
use Devel::Declare ();
use Sub::Install qw(install_sub);

use 5.008;
our $VERSION = "0.02";

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

This document describes Markapl version 0.01

=head1 SYNOPSIS

    package MyView;
    use Markapl;

    sub a_good_page {
        h1("#title") { "Hi" };
        p(".first") { "In the begining, lorem ipsum...." };
        p(style => "color: red;") { "But...." };
    }

    package main;
    MyView->render("a_good_page");

=head1 DESCRIPTION


=head1 INTERFACE 


=over

=item new()

=back

=head1 DIAGNOSTICS

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

Markapl requires no configuration files or environment variables.

=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.

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
