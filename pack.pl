#!/usr/bin/perl
use warnings;
use strict;

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
