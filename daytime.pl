#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Socket;

use constant DEFAULT_ADDR => '173.246.105.50';
use constant PORT => 13;
use constant IPPROTO_TCP => 6;

my $address = shift || DEFAULT_ADDR;
my $packed_addr = inet_aton($address);
my $destination = sockaddr_in(PORT, $packed_addr);

socket(SOCK, PF_INET, SOCK_STREAM, IPPROTO_TCP) or
	die "Can't make socket: $!\n\n";
connect(SOCK, $destination) or
	die "Can't connect: $!\n\n";

print "Daytime client\n";
print <SOCK>;
1;
