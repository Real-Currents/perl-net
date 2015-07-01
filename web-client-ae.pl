#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Non-blocking, concurrent http example from
# http://perlmaven.com/fetching-several-web-pages-in-parallel-using-anyevent
use AnyEvent;
use AnyEvent::HTTP;
use IO::Socket (':DEFAULT', ':crlf'); # Tag :crlf imports CRLF and $CRLF

$/ = CRLF . CRLF;
my $cv = AnyEvent->condvar;
my @urls = @ARGV or die "Usage: web-client-io.pl <URL>\n";

my $data;
for( @urls ) {
	my $url = shift or die "Usage: web-client-io.pl <URL>\n";	
	say "Start $url\n";
#	$cv->begin;
#	http_get $url, sub {
#		my ($html) = @_;
#		say "$url received, Size: ", length $html;
#		$cv->end;
#	};

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

#	STDOUT->print($data) while( $socket->read($data, 1024) > 0 );

	$socket->close();
	$data = undef;
	print "\n";
} 

#say 'Before the event-loop';
#$cv->recv;
say 'Finish';
