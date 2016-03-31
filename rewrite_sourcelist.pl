#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use IO::File;

package Apt::Source;

sub rewriteSource (@);

sub rewriteSource (@) {
    my ($line, $from, $to) = @_;
    $line =~ s/$from/$to/;
    return $line;
}

if ($ARGV[0]) {
    my @versions = ('precise', 'quantal', 'raring', 'saucy', 'trusty');
    my ($from, $to, $in, $out);

    for my $version (@versions) {
        if ($ARGV[1] && $ARGV[1] =~ /$version/) {
            ($from) = $ARGV[1] =~ /($version)/;
            $in = $ARGV[0];
            $in =~ s/ppa\:([\w|\-|\_]+)\/?([\w|\-|\_]+)?\/?([\w|\-|\_]+)?/$1-$2/;
            print "$in \n";
            $in = '/etc/apt/sources.list.d/'. $in .'-'. $from .'.list';
            print "$in \n";
            last;
        }
    }

    for my $version (@versions) {
        if ($ARGV[2] && $ARGV[2] =~ /$version/) {
            ($to) = $ARGV[2] =~ /($version)/;
            $out = $ARGV[0];
            $out =~ s/ppa\:([\w|\-|\_]+)\/?([\w|\-|\_]+)?\/?([\w|\-|\_]+)?/$1-$2/;
            print "$out \n";
            $out = '/etc/apt/sources.list.d/'. $out .'-'. $to .'.list';
            print "$out \n";
            last;
        }
    }

    die "No file defined for the source: ". $ARGV[0] ."\n" if (!$in);

    open my $input, '<', $in
        or die "Could not open input: $!\n";

    open my $output, '>', $out
        or die "Could not open output: $!\n";

    while (<$input>) {
        print $output rewriteSource( $_, $from, $to );
    }

    close $input
        or die "Could not close input: $!\n";

    close $output
        or die "Could not close output: $!\n";

    unlink $in if (-e $out);
}
