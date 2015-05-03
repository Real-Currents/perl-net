#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Socket;
use IO::Handle;
use constant MY_ECHO_PORT => 3000;

my( $bytes_out, 
	$bytes_in) = (0, 0);

my $port = shift || MY_ECHO_PORT;
my $protocol = getprotobyname('tcp');

$SIG{'INT'} = sub {
	print STDERR "bytes_sent: $bytes_out, bytes_recieved: $bytes_in\n";
	exit 0;
};

socket(SOCK, AF_INET, SOCK_STREAM, $protocol) or die "$!\n";

setsockopt(SOCK, SOL_SOCKET, SO_REUSEADDR, 1) or die "$!\n";

my $server_addr = sockaddr_in($port, INADDR_ANY);
bind(SOCK, $server_addr) or die "$!\n";
listen(SOCK, SOMAXCONN) or die "$!\n";

warn "waiting for incoming connections on port $port...\n";

while (1) {
	next unless my $client_addr = accept(SESSION, SOCK);
	my( $port,
		$packed_client_addr ) = sockaddr_in($client_addr);
	warn "Connection from [", inet_ntoa($packed_client_addr), ", $port]\n";
	
	# Process client input here
	
	warn "Connection from [", inet_ntoa($packed_client_addr), ", $port] closed\n";
	close SESSION;
}

close SOCK;
