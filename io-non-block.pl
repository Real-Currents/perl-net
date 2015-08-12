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
sub GetName() {
	my $input = $fh->getline();
	$name = $input if( $input =~ /\w+/ ); 
	unless( $name ) {
		STDOUT->print("Enter you name> ");
	}
}
$| = 1;
STDOUT->print("Enter you name> ");

sub MakeCounter {
	my $cv = AnyEvent->condvar;
	return $cv, AnyEvent->timer (
	  after => 0.033, 	# Non-blocking sleep 30 times per second
	  cb => sub {
			$cv->send;
		}
	)
};

my @aeCounter = MakeCounter;
my $aeWatcher = AnyEvent->io(
	fh => $fh,
	poll => "r",
	cb => sub {
		GetName;
		$aeCounter[0]->send;
	}
);

while(! $name ) {				# Main Event Loop
	$loops++;
	#GetName; 					# Blocking call
	$aeCounter[0]->recv; 		# Half-blocking: Waits for timeout BUT...
	@aeCounter = MakeCounter; 	# Will ALSO read other events like I\O via $aeWatcher
}
	
STDOUT->print("After $loops event loops your name is $name \n") if( $name );

exit;
