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

{   package perl::net;
    use Exporter ('import');
    our @EXPORT_OK = ('GetName');

    sub GetName() {
        my $input = $fh->getline();
        $name = $input if( $input =~ /\w+/ ); 
        unless( $name ) {
            STDOUT->print("Enter you name> ");
        }
    }
    
    1;
}

while(! $name ) { 	# Main Event Loop
    $loops++;
    perl::net::GetName;        # Blocking call
    sleep(0.033);   # Full-blocking: only exception is %SIG
}

STDOUT->print("After $loops event loops your name is $name \n") if( $name );

1;
