#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

#use Test::More 'no_plan';
use Test::Simple tests => 1;

sub helloNet;

print helloNet;

ok( helloNet() eq "Hello, Net!\n", "should say Hello" );

#done_testing();

sub helloNet {
	return "Hello, Net!\n";
}
