#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Socket;
use IO::Handle;
use constant MY_ECHO_PORT => 3000;
use constant MY_ADDRESS => '127.0.0.1';

my $socket = new IO::Handle;

my( $bytes_out, 
	$bytes_in ) = (0, 0);

my $port = shift || MY_ECHO_PORT;
my $protocol = getprotobyname 'tcp';

$SIG{INT} = sub {
	my $sig = shift;
	STDERR->print( "\nTerminated by $sig\n" );
	STDERR->print( "\nbytes_sent: $bytes_out, bytes_recieved: $bytes_in\n\n" );
	exit 0;
};

socket $socket, AF_INET, SOCK_STREAM, $protocol  or die "$!\n";

setsockopt $socket, SOL_SOCKET, SO_REUSEADDR, 1  or die "$!\n";

my $server_addr = sockaddr_in $port, (INADDR_ANY or inet_aton MY_ADDRESS);

warn "Waiting for incoming connections on port $port...\n" if(
		bind($socket, $server_addr) &&
		listen($socket, SOMAXCONN) 
	) or die "$!\n";

while( 1 ) {
	my $session = new IO::Handle;
	next unless my $client_addr = accept $session, $socket ;
	my( $port,
		$packed_client_addr ) = sockaddr_in $client_addr;
	print "Connection from [". inet_ntoa($packed_client_addr) .", $port]\n";
	
	$session->print("Welcome to the echo server!$/") 
		and $session->flush() or warn "$!\n";
	
	# Process client input here
	while( <$session> ) {
		$bytes_in += length $_;
		chomp $_;
		my( $msg ) = $_ =~ /^([\w|\s|\'|\"|\!|\?|\.|\,]+)/;
		next if(! $msg );
		STDOUT->print( $msg ."$/" ) or warn "$!\n";
		
		$session->print("You said: $msg $/") 
			and $session->flush() or warn "$!\n";
		$bytes_out += length $_;
	}
	print $session "Come back soon!$/";
	
	print "Connection from [". inet_ntoa($packed_client_addr) .", $port] closed\n";
	close $session;
}

close $socket;
