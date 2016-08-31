#!/usr/bin/perl

use CGI::Carp qw(fatalsToBrowser);
use CGI;
use strict;
#use warnings;
sub display_results($);
sub match;
my $cgi = CGI->new;
print $cgi->header();
# initialize FORM and set values to run when first loaded
my %FORM;
if ($cgi->param()) {
    # Parameters are defined, therefore the form has been submitted
    display_results($cgi);
} else {
    $FORM{'list'} = '0,2,3,5,6,8,9,10,11,13,30';
    $FORM{'targets'} = '0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,29,31';
}

my @targets = split(/,/, $FORM{'targets'});

my @list = split(/,/, $FORM{'list'});
#@list = @list;
#print @list, ' ', scalar @list;
my @results;
foreach my $int (@targets){
    #print match(@list, $int);
    push(@results, match(\@list, $int));
}


# Build the html
print <<EndOfHTML;
<html><head><title>Array Index Match</title></head>
<body>
<h2>Array Index Match</h2>
Given a sorted array and a target value, return the index if the target is found. If not, return the index where it would be if it were inserted in order. There won't be duplicate values in the array.
<form action='perlHome.pl' method='POST'>
<br/>array = <input id='list' name='list' style='width:250px' type='text' value="$FORM{'list'}"/>
<br/>targets = <input id='targets' name='targets' style='width:250px' type='text' value="$FORM{'targets'}"/>
<br/><input type="submit" value='Calculate'/>
</form>
<ul id='ans'>
EndOfHTML
foreach my $r (0..$#results) {
    print "<li>$targets[$r], $results[$r]</li>";
}
print <<EndOfHTML;
</ul>
</body></html>

EndOfHTML

# Displays the results of the form
sub display_results($) {
    my ($q) = @_;
    $FORM{'list'} = $q->param('list');
    $FORM{'targets'} = $q->param('targets');
}

sub match {
    my @arr = @{@_[0]};
    #print '@arr=', @arr;
    my $tar = @_[1];
    #print ' $tar=', $tar;
    my $l = $#arr + 1; # scalar is returning length +1 so we get last index and add 1 for length 
    #print ' $l=', $l;
    my $half = int($l / 2);
    #print ' $half=', $half, '<br/>';
    if ($l == 1) {
        $half = 0;
    }
    #print 'tar=',$tar,', ', @arr, ', ', $half, '<br/>';
    if ($tar == $arr[$half]) {
        return $half;
    } elsif ($tar < $arr[$half]) {
        if ($l == 1) {
            return 0;
        } elsif ($l == 2) {
            my @nArr = @arr[0];
            return match(\@nArr, $tar);
        } else {
            my @nArr = @arr[0..$half];
            return match(\@nArr, $tar);
        }
    } elsif ($tar > $arr[$half]) {
        if ($l == 1) {
            return 1;
        } else {
            my @nArr = @arr[$half..$l-1];
            return $half + match(\@nArr, $tar);
        }
    }
}
