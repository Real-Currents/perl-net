#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Start Perl process and restart for file changes in working directory
use File::Monitor;
use IO::Handle;

my $pid;
my $proc = shift;
my @args = @ARGV;
my $in = new IO::Handle;
my $out = new IO::Handle;

pipe($in, $out);

sub startProc() {
	print $0 ."\n";
	push(@ARGV, @args);
	do $proc;
}

sub stopProc() {
	my $sig = shift;
	STDERR->print("Recieved $sig\n") if( $sig );
	unless( defined $pid ){
		STDERR->print("Child process has stopped\n\n");
	} elsif( $pid == 0 ) {
		&{$SIG{INT}}($sig);
	}
}

sub startDaemon() {
	warn "Start watching...\n";
	$pid = fork();

	if( $pid == 0 ) {
	# This is the child (forked) process
		print "forked PID=". $$ ."\n";
		# Redirect STDOUT to $out
		STDOUT->fdopen($out, '>');
		close($in);
		startProc;
	} else {
	# This is the parent (daemon) process
		print "daemon PID=". $$ ."\n";
		while (<$in>) {
			STDOUT->print($. ."\n") if $.;
			STDOUT->print($_ ."\n") if $_;
			STDOUT->flush();
		}
	}
	
	return 1;
}

sub stopDaemon() { 
	if( $pid ) {
		undef $pid;
		stopProc;
		warn "Stop watching.\n";
		exit 2 or die "$!\n";
	} else {
		stopProc;
		exit 2 or die "$!\n";
	}
}

$SIG{INT} = \&stopDaemon;
$SIG{TERM} = \&stopProc;

startDaemon;
