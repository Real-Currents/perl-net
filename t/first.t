#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Test::Simple tests => 1; #'no_plan';

sub helloNet {
	return "Hello, Net!\n";
}

ok( helloNet() eq "Hello, Net!\n" );
