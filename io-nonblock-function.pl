#!/usr/bin/env perl
use 5.10.1;
use warnings;
use strict;

use IO::Handle;
use AnyEvent;

my $fh;
my $loops = 0;
my $name;

$| = 1;
STDOUT->print("Enter you name> ");

{   package perl::net;

    sub GetName() {
        $fh = \*STDIN;
        my $input = $fh->getline();
        $name = $input if( $input =~ /\w+/ ); 
        unless( $name ) {
            STDOUT->print("Enter you name> ");
        }
    }
    
    sub MakeCounter {
        my $condvar = AE::cv;
        return {
            'cv' => $condvar, 
            'ticker' => AE::timer(
                0.033,                      # Non-blocking sleep 30 times per second
                0,
                sub {
                    $condvar->send;
                }
            )
        }
    }
    
    1;
}

my $aeCounter = perl::net::MakeCounter;
my $aeWatcher = AE::io(
    $fh,
    0,                                      # $watch_write == false
    sub {
        perl::net::GetName;                 # Blocking call nested in async callback
        $aeCounter->{cv}->send;             # Interrupts $aeCounter timeout
    }
);

while(! $name ) {                           # Main Event Loop
    $loops++;
    $aeCounter->{cv}->recv;                 # Half-blocking: Waits for timeout BUT...
    $aeCounter = perl::net::MakeCounter; 	# ALSO reads other events like I\O via $aeWatcher
}

STDOUT->print("After $loops event loops your name is $name \n") if( $name );

1;
