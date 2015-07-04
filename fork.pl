#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

print "PID=". $$ ."\n";

my $child = fork();
die "$!\n" unless( defined $child );

print "Child process started...\n" if( $child > 0 );

if(! $child ) {
	# Now in child process
	print "forked PID=". $$ ."\n";
	local *STDOUT;
#	return exec( 'ls', '-1');
}

# Still in parent process;
print "daemon PID=". $$ ."\n";

while( sleep(1) ) {} # Will exit on Interrupt, Terminate or Kill
