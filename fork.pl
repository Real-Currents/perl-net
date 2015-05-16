#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

print "PID=". $$ ."\n";

my $child = fork();
die "$!\n" unless( defined $child );

print "Child PID=". $child ."\n" if( $child > 0 );
