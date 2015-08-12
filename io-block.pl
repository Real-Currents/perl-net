#!/usr/bin/env perl
use 5.10.1;
use warnings;
use strict;

use IO::Handle;

my $fh = \*STDIN;
my $loops = 0;
my $name;
sub GetName() {
	unless( $name ) {
		$name = $fh->getline(); 
	}
}
$| = 1;
STDOUT->print("Enter you name> ");

while(! $name ) {	
	GetName; # Blocking call
	$loops++;
	sleep(1); # Full-blocking: only exception is %SIG
}
	
STDOUT->print("After $loops event loops your name is $name \n") if( $name );

exit;
