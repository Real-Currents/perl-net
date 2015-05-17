#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Start Perl process and restart for file changes in working directory
use File::Monitor;
use IO::Handle;

my $pid;
my $proc = shift;
my $in = new IO::Handle;
my $out = new IO::Handle;

pipe($in, $out);

sub startProc() {
	do $proc;
}

sub stopProc() {
	my $sig = shift;
	warn "Recieved $sig\n" if( $sig );
	unless( defined $pid ){
		warn "Child process has stopped\n\n";
	} elsif( $pid == 0 ) {
		print "forked PID=". $$ ."\n";
		startProc;
	}
	#exit 2 or die "$!\n";
}

sub stopDaemon() { 
	kill 2, $pid and undef $pid;
	stopProc;
	warn "Stop watching.\n";
	exit 2 or die "$!\n";
}

$SIG{INT} = \&stopDaemon;
$SIG{TERM} = \&stopProc;

warn "Start watching...\n";
$pid = fork();

if( $pid == 0 ) {
# This is the child (forked) process
	print "forked PID=". $$ ."\n";
	close($in);
	startProc;
} else {
# This is the parent (daemon) process
	print "daemon PID=". $$ ."\n";
	# Clear additional command line arguments
	%ARGV = ();
	#close($out); 
	while (<$in>) {
		stopProc;
		STDOUT->print($. ."\n") if $.;
		STDOUT->flush();
	}
}

1;
