#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use IO::Socket (':DEFAULT', ':crlf'); # Tag :crlf imports CRLF and $CRLF

$/ = CRLF . CRLF;

my $data;
my $url = shift or die "Usage: web-client-io.pl <URL>\n";
my( $host, $path ) = $url =~ /(?:^http:\/\/)?([^\/]+)(\/[^\#]*)?/;
$path = "/" if(! $path );
	
my $socket = IO::Socket::INET->new( 'PeerAddr' 	=> $host,
									'PeerPort' 	=> 'http(80)' )
	or die "$!\n";
	
$socket->print( "GET $path HTTP/1.0" 	=> CRLF,		# Initial Request line
				"Host: $host" 			=> CRLF, CRLF ); # Header lines and end Request

my $header = $socket->getline;
$header =~ s/$CRLF/\n/g;  # Replace CRLF with \n 
STDOUT->print($header);

#STDOUT->print($data) while( $socket->read($data, 1024) > 0 );

print "\n";
