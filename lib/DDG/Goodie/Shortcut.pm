package DDG::Goodie::Shortcut;
# ABSTRACT: Display keyboard shortcut for an action.

use DDG::Goodie;
use LWP::UserAgent;
use HTML::TreeBuilder;

triggers any => 'shortcut','keyboard shortcut', 'key combination';

zci is_cached => 1;
zci answer_type => 'shortcut';

primary_example_queries 'windows show desktop shortcut';
secondary_example_queries 'ubuntu shortcut new folder', 'paste keyboard shortcut';
description 'keyboard shortcuts';
name 'Shortcut';
topics 'computing';
category 'computing_info';
attribution github => ['https://github.com/dariog88a','dariog88a'],
            email => [ 'mailto:dariog88@gmail.com', 'dariog88' ],
            twitter => ['http://twitter.com/dariog88','dariog88'];

handle remainder_lc => sub {
    #replace all OS words with starting char
    s/windows|win|xp|vista|seven/W/gi;
    s/mac|osx/M/gi;
    s/linux|ubuntu|debian|fedora|kde|gnome/L/gi;

    sub trim($) {
        my $s = shift;
        $s =~ s/ +/ /gs;
        $s =~ s/^\s+|\s+$//g; 
        return $s;
    }

    #get OS char (if any)
    my $search = $_;
    $search =~ s/[WML]//g; #remove all OS chars from search
    my $os = substr($_,0,1); #save first char
    $os =~ s/[^WML]//g; #remove if not an OS char
    $search = trim($search);

    #get wikipedia page content
    my $url = 'https://en.wikipedia.org/wiki/Table_of_keyboard_shortcuts';
    my $content = LWP::UserAgent->new()->get($url)->content;
    defined $content or return;

    #find the first row that starts with the searched action
    my $tree = HTML::TreeBuilder->new_from_content($content);
    my $heading = $tree->look_down(
        _tag => 'th',
        sub {
            $_[0]->as_trimmed_text() =~ /^$search/i #matches only the start
        }
    );

    #return if no row was found
    if (!defined $heading) { return; }

    my %columns = (W=>'Windows',M=>'Mac OS',L=>'KDE/GNOME');
    my $answer = 'The shortcut for ' . $heading->as_trimmed_text();
    my $keys;

    #get the (not empty) column content for the searched OS or for all of them if OS not specified
    if ($os eq 'W') {
        $keys = $heading->right()->as_trimmed_text();
        if (!$keys) { return; }
    } elsif ($os eq 'M') {
        $keys = $heading->right()->right()->as_trimmed_text();
        if (!$keys) { return; }
    } elsif ($os eq 'L') {
        $keys = $heading->right()->right()->right()->as_trimmed_text();
        if (!$keys) { return; }
    } else {
        $answer .= ' is:';
        $keys = $heading->right()->as_trimmed_text();
        if ($keys) { $answer .= "\n" . $columns{W} . ': ' . $keys; }
        $keys = $heading->right()->right()->as_trimmed_text();
        if ($keys) { $answer .= "\n" . $columns{M} . ': ' . $keys; }
        $keys = $heading->right()->right()->right()->as_trimmed_text();
        if ($keys) { $answer .= "\n" . $columns{L} . ': ' . $keys; }
    }

    if ($os) { $answer .= ' in ' . $columns{$os} . ' is ' . $keys; }

    my $source = "\n" . '<a href="' . $url . '">More at Wikipedia</a>';
    return $answer, html => "$answer $source";
};

1;
