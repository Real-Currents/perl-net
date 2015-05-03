#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Socket qw(AF_INET);

while( my $address = shift ) {
	my $packed_addr = gethostbyname $address;	
	unless( $packed_addr ) {
		print "$address => ? \n\t";
		next;
	}
	
	my( $name, 
		$aliases, 
		$family, 
		$len, 
		$addr )= gethostbyaddr $packed_addr, AF_INET;
	print <<DOMAIN_INFO;
Name: $name 
Aliases: $aliases 
Net-Family: $family 
Length: $len 
domain info provided by gethostbyaddr
DOMAIN_INFO

}
