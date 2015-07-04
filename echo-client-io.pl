#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use IO::Socket (':DEFAULT', ':crlf');

my( $bytes_out, 
	$bytes_in ) = (0, 0);
	
my $host = shift || 'localhost';
my $port = shift || 'echo';
my $socket = IO::Socket::INET->new("$host:$port") or die $@;

# Print server's greeting
my $msg_in = <$socket>;
STDOUT->print( $msg_in ) if( defined($msg_in) );

while( defined(my $msg_out = STDIN->getline()) ) {
	$socket->print( $msg_out .CRLF );

	local $/ = CRLF; 	# Localize the end-line assignment so that it resets after each loop
	my $msg_in = undef;

	while( defined($msg_in = <$socket>) and ($msg_in =~ /^([\w|\s|\'|\"|\!|\?|\.|\,]+)/) ) {
		STDOUT->print( $msg_in );
		last;
	}

	$bytes_out += length($msg_out);
	$bytes_in += length($msg_in) if( defined($msg_in) );
}

$socket->close or warn $@;
STDERR->print( "bytes sent = $bytes_out, bytes received = $bytes_in\n" );
