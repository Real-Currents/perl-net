#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Non-blocking, concurrent http example from
# http://perlmaven.com/fetching-several-web-pages-in-parallel-using-anyevent
use AnyEvent;
use AnyEvent::HTTP;

my $cv = AnyEvent->condvar;
my @urls = @ARGV or die "Usage: web-client-io.pl <URL>\n";

my $data;
for( @urls ) {
	my $url = shift or die "Usage: web-client-io.pl <URL>\n";	
	say "Start $url\n";
	
	my( $host, $path ) = $url =~ /(?:^http:\/\/)?([^\/]+)(\/[^\#]*)?/;
	$path = "/" if(! $path );
	
	$cv->begin;
	http_get "http://$host$path", sub {
		$data = \@_;
		say "$url received, Size: ", length($data->[0]);

		my $header = $data->[1];
		print "$_: ". $header->{$_} ."\n" for( keys %$header );

#		print $data->[0];

		$data = undef;
		print "\n";
		$cv->end;
	};
} 

$cv->recv;
say 'Finish';
