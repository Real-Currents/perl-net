#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Test out some Perl network functions 
# by connecting to local daytime server
# Checkout remote daytime servers @
# http://tf.nist.gov/tf-cgi/servers.cgi

use IO::Socket (':DEFAULT', ':crlf');

print "Daytime client \
===============================================================\n";

my $address = shift || 'time.nist.gov';
my $lend = $/;
$/ = CRLF;

my $socket = IO::Socket::INET->new("$address:daytime") or
				die "Can't connect to daytime service at $address: $!\n";

my $time = $socket->getline();
chomp $time;
print $time ."\n";
