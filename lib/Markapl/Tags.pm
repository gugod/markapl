package Markapl::Tags;

use strict;
use warnings;

sub w3c_html4 {
    qw(
       a abbr acronym address applet area b base basefont bdo big
       blockquote body br button caption center cite code col colgroup
       dd del dfn dir div dl dt em fieldset font form frame frameset
       h1 h2 h3 h4 h5 h6 head hr html i iframe img input ins isindex
       kbd label legend li link map menu meta noframes noscript object
       ol optgroup option p param pre q s samp script select small
       span strike strong style sub sup table tbody td textarea tfoot
       th thead title tr tt u ul var
    );
}

sub html4_perl_common {
    qw(base link map q s sub tr);
}

sub html {
    # removed common ones. add replacements
    qw(
       a abbr acronym address applet area b basefont bdo big
       blockquote body br button caption center cite code col colgroup
       dd del dfn dir div dl dt em fieldset font form frame frameset
       h1 h2 h3 h4 h5 h6 head hr html i iframe img input ins isindex
       kbd label legend li menu meta noframes noscript object
       ol optgroup option p param pre samp script select small
       span strike strong style sup table tbody td textarea tfoot
       th thead title tt u ul var

       html_base html_link html_map html_q html_s html_sub html_tr
       cell row
    );
}

1;

