#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Socket;
use IO::File;
use IO::Handle;
use constant MY_ECHO_PORT => 3000;
use constant MY_ADDRESS => '127.0.0.1';

my $socket = new IO::File;

my( $bytes_out, 
	$bytes_in) = (0, 0);

my $port = shift || MY_ECHO_PORT;
my $protocol = getprotobyname 'tcp';

$SIG{'INT'} = sub {
	print STDERR "bytes_sent: $bytes_out, bytes_recieved: $bytes_in\n";
	exit 0;
};

socket $socket, AF_INET, SOCK_STREAM, $protocol  or die "$!\n";

setsockopt $socket, SOL_SOCKET, SO_REUSEADDR, 1  or die "$!\n";

my $server_addr = sockaddr_in $port, (INADDR_ANY or inet_aton MY_ADDRESS);

warn "Waiting for incoming connections on port $port...\n" if(
		bind($socket, $server_addr) &&
		listen($socket, SOMAXCONN) 
	) or die "$!\n";

while (1) {
	my $session = new IO::File;
	next unless my $client_addr = accept $session, $socket ;
	my( $port,
		$packed_client_addr ) = sockaddr_in $client_addr;
	warn "Connection from [". inet_ntoa($packed_client_addr) .", $port]\n";
	
	print $session "Welcome to the echo server!";
	
	# Process client input here
	while (<$session>) {
		$bytes_in += length $_;
		chomp $_;
		
		print $session "\nYou said: $_ \n";
		$bytes_out += length $_;
		
		last;
	}
	print $session "Come back soon!";
	
	warn "Connection from [". inet_ntoa($packed_client_addr) .", $port] closed\n";
	close $session;
}

close $socket;
