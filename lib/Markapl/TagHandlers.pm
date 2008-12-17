package Markapl::TagHandlers;

use strict;
use warnings;
use Data::Dump qw(pp);
use Devel::Caller qw(caller_vars caller_cv);
use PadWalker qw(peek_my peek_our peek_sub closed_over);

    our ($Declarator, $Offset);
    sub skip_declarator {
        $Offset += Devel::Declare::toke_move_past_token($Offset);
    }

    sub skipspace {
        $Offset += Devel::Declare::toke_skipspace($Offset);
    }

    sub strip_name {
        skipspace;
        if (my $len = Devel::Declare::toke_scan_word($Offset, 1)) {
            my $linestr = Devel::Declare::get_linestr();
            my $name = substr($linestr, $Offset, $len);
            substr($linestr, $Offset, $len) = '';
            Devel::Declare::set_linestr($linestr);
            return $name;
        }
        return;
    }

    sub strip_proto {
        skipspace;

        my $linestr = Devel::Declare::get_linestr();
        if (substr($linestr, $Offset, 1) eq '(') {
            my $length = Devel::Declare::toke_scan_str($Offset);
            my $proto = Devel::Declare::get_lex_stuff();
            Devel::Declare::clear_lex_stuff();
            $linestr = Devel::Declare::get_linestr();
            substr($linestr, $Offset, $length) = '';
            Devel::Declare::set_linestr($linestr);
            return $proto;
        }
        return;
    }

    sub shadow {
        my $pack = Devel::Declare::get_curstash_name;
        Devel::Declare::shadow_sub("${pack}::${Declarator}", $_[0]);
    }

    sub make_proto_unwrap {
        my ($proto) = @_;
        # my $inject = 'my ($self) = @_;';
        # $inject .= "my \$attr = { $proto };" if defined($proto) && length($proto);
        return "";
    }

    sub inject_if_block {
        my $inject = shift;
        skipspace;
        my $linestr = Devel::Declare::get_linestr;
        if (substr($linestr, $Offset, 1) eq '{') {
            substr($linestr, $Offset+1, 0) = $inject;
            Devel::Declare::set_linestr($linestr);
        }
    }

    my %alt = (
        'cell' => 'td',
        'row' => 'tr',
    );

    sub tag_parser_for {
        my ($tag) = @_;
        $tag = $alt{$tag} if defined($alt{$tag});

        return sub {
            local ($Declarator, $Offset) = @_;
            skip_declarator;
            my $name = strip_name;
            my $proto = strip_proto;
            inject_if_block(
                make_proto_unwrap($proto)
            );

            if (defined $name) {
                $name = join('::', Devel::Declare::get_curstash_name(), $name)
                    unless ($name =~ /::/);
                shadow(sub (&) { no strict 'refs'; *{$name} = shift; });
            } else {
                shadow(
                    sub (&) {
                        my $block = shift;
                        my $attr = "";
                        if (defined $proto) {
                            my @attr;
                            eval "\@attr = ( $proto )";
                            if ($@) {
                                my $vars = peek_sub(caller_cv(1));
                                my $var_declare = "";
                                for my $varname (keys %$vars) {
                                    $var_declare .= "my $varname = " . pp(${$vars->{$varname}}) . ";";
                                }
                                eval "{$var_declare \n\@attr = ($proto);\n}";
                            }

                            if (@attr == 1) {
                                # Special case.
                                # h1("#myid") { ... }

                                my $css = $attr[0];
                                while($css =~ /([#\.])(\w+)/g) {
                                    if ($1 eq '#') {
                                        $attr .= qq{ id="$2"};
                                    }
                                    else {
                                        $attr .= qq{ class="$2"};
                                    }
                                }
                            }
                            else {
                                my ($k, $v) = (shift @attr, shift @attr);
                                while ($k && $v) {
                                    $attr .= " $k=\"$v\"";
                                    ($k, $v) = (shift @attr, shift @attr);
                                }
                            }
                        }

                        my $buf = "<${tag}${attr}>";

                        Markapl->new_buffer_frame;

                        Markapl->buffer->append( $block->() );

                        $buf .= Markapl->end_buffer_frame->data;

                        $buf .= "</$tag>";

                        Markapl->buffer->append( $buf );

                        return;
                    }
                );
            }
        }
    }

    1;
