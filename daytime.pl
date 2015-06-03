#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Test out some Perl network functions 
# by connecting to local daytime server
# Checkout remote daytime servers @
# http://tf.nist.gov/tf-cgi/servers.cgi

use Socket ('AF_INET', 'SOCK_STREAM', 'inet_aton', 'inet_ntoa', 'sockaddr_in');

use constant DEFAULT_ADDR => 'time.nist.gov';
use constant PORT => 13;
use constant IPPROTO_TCP => 6;

print "Daytime client \
===============================================================\n";
# Important functions
#
# ... return scaler context...
# $packed_addr= 		gethostbyname $name
# ... return list context...
# ( $name, 
#	$aliases, 
#	$family,
#	$len,
#	$packed_addr )= 	gethostbyname $name
#
# ... return scaler context...
# $name= 				gethostbyaddr $packed_addr, $family
# ... return list context...
# ( $name, 
#	$aliases, 
#	$family,
#	$len,
#	$packed_addr )= 	gethostbyaddr $packed_addr, $family
#
# ... return scaler context...
# $number=				getprotobyname $protocol_name
# ... return list context...
# ( $protocol_name,
#	$aliases,
#	$number )=			getprotobyname $protocol_name
#
# ... return scaler context...
# $protocol_name=		getprotobynumber $protocol_number
# ... return list context...
# ( $protocol_name,
#	$aliases,
#	$number )=			getprotobynumber $protocol_number
#
#
# use Socket;
#
# $packed_addr= 		inet_aton $dotted_quad
# $dotted_quad=			inet_ntoa $packed_address
# $socket_addr= 		sockaddr_in $port, $packed_addr
# ($port, $packed_addr)= sockaddr_in $socket_addr
# $socket_addr= 		pack_sockaddr_in $port, $packed_addr
# ($port, $packed_addr)= unpack_sockaddr_in $socket_addr

my $protocol = getprotobyname('tcp') || IPPROTO_TCP;
my $address = shift || DEFAULT_ADDR;

while( $address ) {
	my $packed_addr = inet_aton($address); 		# Alternative to gethostbyname($address);	
	unless( $packed_addr ) {
		print "$address => ? \n\t";
		$packed_addr = inet_aton(DEFAULT_ADDR); # If IP cannot be resolved use NIST servers
		#next;
	} else {
		my $dotted_quad = inet_ntoa($packed_addr);
		print "$address => $dotted_quad \n\t";
	}
	
	my $socket;
	socket($socket, AF_INET, SOCK_STREAM, $protocol) or # ($handle, $family, $type, $protocol_num)
		print "Can't make socket: $!\n\n" and next;
	
	my $destination = sockaddr_in(PORT, $packed_addr);
	connect($socket, $destination) or 					# ($handle, $socket_addr)
		print "Can't connect: $!\n\n" and next;

	print <$socket>;
	print "\n";
	
	$address = shift || ''; 	# Set address to next arg or quit
}
