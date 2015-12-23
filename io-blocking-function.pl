#!/usr/bin/env perl
use 5.10.1;
use warnings;
use strict;

use IO::Handle;

my $fh = \*STDIN;
my $loops = 0;
my $name;

$| = 1;
STDOUT->print("Enter you name> ");

sub GetName() {
    my $input = $fh->getline();
    $name = $input if( $input =~ /\w+/ ); 
    unless( $name ) {
        STDOUT->print("Enter you name> ");
    }
}

while(! $name ) { 	# Main Event Loop
    $loops++;
    GetName;        # Blocking call
    sleep(0.033);   # Full-blocking: only exception is %SIG
}

STDOUT->print("After $loops event loops your name is $name \n") if( $name );

exit;
