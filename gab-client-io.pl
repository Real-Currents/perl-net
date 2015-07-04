#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use IO::Socket (':DEFAULT', ':crlf');

sub user_to_host;
sub host_to_user;

my( $bytes_out, 
	$bytes_in ) = (0, 0);
	
my $host = shift || 'localhost';
my $port = shift || 'echo';

my $socket = IO::Socket::INET->new("$host:$port") or die $@;
my $child = fork();
die "Can't fork: $!" unless defined($child);

if( $child ) {
	$SIG{CHLD} = sub { exit 0; };
	user_to_host($socket);
	$socket->shutdown(1);
	sleep;
} else {
	host_to_user($socket);
	warn "Connection closed by remote host.\n" or die $!;
}

sub user_to_host {
	my $sock = shift;
	while( <> ) {
		chomp;
		$sock->print( $_, CRLF );
	}
}

sub host_to_user {
	my $sock = shift;
	$/ = CRLF;
	while( <$sock> ) {
		chomp;
		STDOUT->print( $_, "\n" );
	}
}
