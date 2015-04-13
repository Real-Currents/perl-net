#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Socket qw{AF_INET};

my( $ip, $packed );
$ip = '192.168.2.2';
print $ip ."\n";

my( $a, $b, $c, $d ) = split /\./, $ip;
my $i = 0;
print map { 
		$i++;
		"byte ". $i .": ". $_ ."\n";		# Map returns the last statement in the block to print
	} ($a, $b, $c, $d);

$packed = pack 'C4', $a, $b, $c, $d;		# Pack as 4 unsiged bytes
print "packed: ". unpack('H*', $packed) ."\n";			# Print hexadecimal representation of $packed

$packed = pack 'C*', $a, $b, $c, $d;		# Pack as many unsiged bytes as needed
print "packed: ". unpack('H*', $packed) ."\n";			# Print hexadecimal representation of $packed

( $a, $b, $c, $d ) = unpack 'C4', $packed;
print( $ip ."\n") if( $ip eq join '.', $a, $b, $c, $d );

$ip = gethostbyname('localhost');
print "packed by gethostbyname: ". unpack('H*', $packed) ."\n";	
my( $name, 
	$aliases, 
	$family, 
	$len, 
	$packed_addr )= 	gethostbyaddr $ip, AF_INET;
print "Name: $name, Aliases: $aliases, Net-Family: $family and Length: $len from gethostbyaddr\n";
