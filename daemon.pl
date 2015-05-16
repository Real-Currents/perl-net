#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Start Perl process and restart for file changes in working directory
use File::Monitor;
use IO::Handle;

sub stopDaemon();
sub startProc();
sub stopProc();

my $pid;
my $proc = shift;

#$SIG{CHLD} = "IGNORE";
$SIG{'INT'} = \&stopDaemon;
$SIG{'KILL'} = \&stopProc;

print "Start watching...\n";

$pid = fork();
if( $pid > 0 ) {
	# This is the parent (daemon) process
	print "daemon PID=". $$ ."\n";
} else {
	# This is the child (forked) process
	print "forked PID=". $$ ."\n";
}
startProc;

while (<>) {
	STDIN->print( $. ."\n" );
	STDIN->flush();
}

sub startProc() {
	do $proc if( $pid > 0);
}

sub stopProc() {
	unless( defined $pid ){
		"Child process has stopped\n\n";
	}
}

sub stopDaemon() { 
	print "Stop watching.\n";
	exit 2 or die "$!\n";
}

1;
