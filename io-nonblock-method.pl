#!/usr/bin/env perl
use 5.10.1;
use warnings;
use strict;

use IO::Handle;
use AnyEvent;
use AnyEvent::Strict;

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
sub MakeCounter {
	my $condvar = AnyEvent->condvar;
	return {
		'cv' => $condvar, 
		'ticker' => AnyEvent->timer(
		  after => 0.033, 			# Non-blocking sleep 30 times per second
		  cb => sub {
				$condvar->send;
			}
		)
	}
};

my $aeCounter = MakeCounter;
my $aeWatcher = AnyEvent->io(
	fh => $fh,
	poll => "r",
	cb => sub {
		GetName; 				# Blocking call nested in async callback
		$aeCounter->{cv}->send;
	}
);

while(! $name ) { 				# Main Event Loop
	$loops++;
	$aeCounter->{cv}->recv; 	# Half-blocking: Waits for timeout BUT...
	$aeCounter = MakeCounter; 	# Will ALSO read other events like I\O via $aeWatcher
}
	
STDOUT->print("After $loops event loops your name is $name \n") if( $name );

exit;
