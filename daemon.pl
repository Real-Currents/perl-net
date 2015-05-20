#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Start Perl process and restart for file changes in working directory
use Cwd;
use File::Monitor;
use IO::Handle;

my $pid;
my $proc = shift or die "No Perl script to run\n";
my @args = @ARGV;
my $in;
my $out;
my $watcher = File::Monitor->new();

sub startDaemon();
sub startProc();
sub stopProc($);
sub stopDaemon($);

$SIG{INT} = \&stopDaemon;
$SIG{TERM} = \&stopProc;

startDaemon;

sub startDaemon() {
	$in = new IO::Handle;
	$out = new IO::Handle;
	
	warn "Start watching...\n";
	pipe($in, $out);
	$watcher->watch( {
		name        => getcwd,
		recurse     => 1,
		callback    => {
			change => sub {
				my ($name, $event, $change) = @_;
				# Do stuff
				stopProc 'TERM';
			}
		}
	} );
	$watcher->scan();
	$pid = fork();

	if( $pid == 0 ) {
	# This is the child (forked) process
		print "forked PID=". $$ ."\n";
		close($in);
		# Redirect STDOUT to $out
		STDOUT->fdopen($out, '>');
		startProc;
	} else {
	# This is the parent (daemon) process
		print "daemon PID=". $$ ."\n";
		close($out);
		while ($in->opened) {
			$_ = '';
			my @changes = $watcher->scan();
			
			unless( defined @changes ) {
				#$in->sysread($_,50,length($_));
				STDOUT->print($. ."\n") if $.;
				STDOUT->print($_ ."\n") if $_;
				STDOUT->flush();
			} else {
				for (@changes) {
					STDOUT->print($_->name, " has changed\n");
				}
				return startDaemon;
			}
		}
	}
}

sub startProc() {
	push(@ARGV, @args);
	do $proc;
}


sub stopProc( $ ) {
	my $sig = shift;
	STDERR->print("Recieved $sig\n") if( $sig );
	unless( defined $pid ){
		STDERR->print("Child process has stopped\n\n");
	} elsif( $pid == 0 ) {
		&{$SIG{INT}}($sig);
	} else {
		STDERR->print("Which process is this?\n\n");
		kill $sig, $pid;
	}
}

sub stopDaemon( $ ) { 
	if( $pid ) {
		undef $pid;
		stopProc shift;
		warn "Stop watching.\n";
		exit 2 or die "$!\n";
	} else {
		stopProc shift;
		exit 2 or die "$!\n";
	}
}

1;
