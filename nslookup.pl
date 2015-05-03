#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Socket qw{AF_INET inet_aton inet_ntoa};

while( my $address = shift ) {
	my $packed_addr = inet_aton $address;	
	unless( $packed_addr ) {
		print "$address => ? \n\t";
		next;
	}
	
	my $ip_addr = inet_ntoa  $packed_addr;
	my( $name, 
		$aliases, 
		$family, 
		$len, 
		$addr )= gethostbyaddr $packed_addr, AF_INET;
	print <<DOMAIN_INFO;
IP: $ip_addr
Name: $name 
Aliases: $aliases 
Net-Family: $family 
Length: $len 
domain info provided by gethostbyaddr
DOMAIN_INFO

}
