#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Start Perl process and restart for file changes in working directory
use File::Monitor;
use IO::Handle;

my $pid;
my $proc = shift;

sub startProc() {
	do $proc;
}

sub stopProc() {
	unless( defined $pid ){
		warn "Child process has stopped\n\n";
	}
}

sub stopDaemon() { 
	kill 2, $pid and undef $pid;
	stopProc;
	warn "Stop watching.\n";
	exit 2 or die "$!\n";
}

#$SIG{CHLD} = "IGNORE";
$SIG{'INT'} = \&stopDaemon;
$SIG{'KILL'} = \&stopProc;

warn "Start watching...\n";
$pid = fork();

if(! $pid ) {
# This is the child (forked) process
	print "forked PID=". $$ ."\n";
	startProc;
} else {
# This is the parent (daemon) process
	print "daemon PID=". $$ ."\n";
	# Clear additional command line arguments
	%ARGV = ();
	while (<STDIN>) {
		stopProc;
		STDOUT->print($. ."\n") if $.;
		STDOUT->flush();
	}
}

1;
