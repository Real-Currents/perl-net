#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Test out some Perl network functions 
# by connecting to local daytime server
# Checkout remote daytime servers @
# http://tf.nist.gov/tf-cgi/servers.cgi

use Socket;

use constant DEFAULT_ADDR => '127.0.0.1';
use constant PORT => 13;
use constant IPPROTO_TCP => 6;

print "Daytime client \
===============================================================\n";
# Important functions
#
# $packed_addr= 		gethostbyname $name
# ( $name, 
#	$aliases, 
#	$family,
#	$len,
#	$packed_addr )= 	gethostbyname $name
#
# $name= 				gethostbyaddr $packed_addr, $family
# ( $name, 
#	$aliases, 
#	$family,
#	$len,
#	$packed_addr )= 	gethostbyaddr $packed_addr, $family
# 
# From Socket:
#
# $packed_addr= 		inet_aton $dotted_quad
# $dotted_quad=			inet_ntoa $packed_address
# $socket_addr= 		sockaddr_in $port, $packed_addr
# ($port, $packed_addr)= sockaddr_in $socket_addr
# $socket_addr= 		pack_sockaddr_in $port, $packed_addr
# ($port, $packed_addr)= unpack_sockaddr_in $socket_addr

while( my $address = shift ) {
	my $packed_addr = inet_aton($address); #gethostbyname($address);	
	unless( $packed_addr ) {
		print "$address => ? \n\t";
		$packed_addr = inet_aton(DEFAULT_ADDR); # Use localhost if IP cannot be resolved
		#next;
	} else {
		my $dotted_quad = inet_ntoa($packed_addr);
		print "$address => $dotted_quad \n\t";
	}
	
	my $socket;
	socket($socket, AF_INET, SOCK_STREAM, IPPROTO_TCP) or 	# ($handle, $family, $type, $protocol_num)
		print "Can't make socket: $!\n\n" and next;
	
	my $destination = sockaddr_in(PORT, $packed_addr);
	connect($socket, $destination) or 						# ($handle, $socket_addr)
		print "Can't connect: $!\n\n" and next;

	print <$socket>;
	print "\n";
}
1;
