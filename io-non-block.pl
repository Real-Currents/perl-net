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
	unless( $name ) {
		$name = $fh->getline(); 
	}
}
$| = 1;
STDOUT->print("Enter you name> ");

sub MakeCounter {
	my $cv = AnyEvent->condvar;
	return $cv, AnyEvent->timer (
	  after => 1, 	# Non-blocking sleep for 1 second
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

while(! $name ) {	
	#GetName; # Blocking call
	$loops++;
	$aeCounter[0]->recv;
	@aeCounter = MakeCounter; 	# Half-blocking: Waits for timeout BUT...
								# Will ALSO read other events like I\O via $aeWatcher
}
	
STDOUT->print("After $loops event loops your name is $name \n") if( $name );

exit;
