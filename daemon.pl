#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Start Perl process and restart for file changes in working directory
use File::Monitor;
use IO::Handle;

sub stopDaemon();

my $pid;
my $proc = shift;
my $in = new IO::Handle;

$SIG{CHLD} = "IGNORE";
$SIG{'INT'} = \&stopDaemon;

print "PID=". $$ ."\n";

print "Start watching...\n";

$in->autoflush();
$pid = fork and do $proc; 

sub stopDaemon() { 
	print "Stop watching.\n";
	#kill 2, $pid;
	exit 2 or die "$!\n";
};

while (<>) {
	print $. ".\n";
}

stopDaemon;
