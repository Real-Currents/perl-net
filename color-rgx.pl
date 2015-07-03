#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Term::ANSIColor ':constants';

my %target = ();
my ($arg, $clr);
my @presets = ( '\d+\.\d+\.\d+\.\d+', GREEN,
				'[A-Za-z]+', YELLOW );
my @colors = (@ARGV);

#unless( @ARGV > 0 ) {
#	print "Usage: color-rgx.pl [regex] [color], [regex] [color], ...\n";
#	exit;
#}

while( $arg = shift(@colors) ) {
	$clr = shift(@colors);
	($clr) =~ /(\w+),?/ if( $clr );

	print "$arg => $clr\n";
	
	$target{$arg} = eval($clr);
}

my $rst = RESET;

while( <> ) {
	foreach my $x ( keys(%target) ) {
		s/($x)/$target{$x}$1$rst/g;
	}
	print;
}
