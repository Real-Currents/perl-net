#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Socket qw{AF_INET};
use Socket qw{inet_ntoa};

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
print "unpacked by inet_ntoa: ". inet_ntoa($packed) ."\n\n";

$ip = gethostbyname('localhost');
print "localhost\n";
print "packed by gethostbyname: ". unpack('H*', $ip) ."\n";	
print "unpacked by inet_ntoa: ". inet_ntoa($ip) ."\n";
my( $name, 
	$aliases, 
	$family, 
	$len, 
	$packed_addr )= 	gethostbyaddr $ip, AF_INET;
print "Name: $name, Aliases: $aliases, Net-Family: $family and Length: $len from gethostbyaddr\n\n";
