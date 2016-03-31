#!/usr/bin/env perl
use 5.10.1;
use warnings;
use strict;

use AnyEvent;

my $cv = AnyEvent->condvar;

my $wait_one_and_a_half_seconds = AnyEvent->timer (
  after => 3,  # after how many seconds to invoke the cb?
  cb    => sub { # the callback to invoke
	 $cv->send;
	 print "TIMEOUT\n";
  },
);

while( 1 ) {
	# now wait till our time has come
	$cv->recv;
	$cv = AnyEvent->condvar;
	$wait_one_and_a_half_seconds = AnyEvent->timer (
	  after => 1.5,  # after how many seconds to invoke the cb?
	  cb    => sub { # the callback to invoke
		 $cv->send;
		 print "TIMEOUT\n";
	  },
	);
}

exit;
