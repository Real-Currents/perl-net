#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Test::More;# 'no_plan';
use Fcntl;

use IO::Handle;

# Create handle to mock STDIN input
my( $input, 
    $stdin ) = (
        (-p STDIN )? STDIN->getline() : "John",
        new IO::Handle()
    );
local *STDIN = $stdin;
#open $stdin, '<', \$input;
#print "Input: ". STDIN->getline() ."\n";

open $stdin, '<', \$input;
require_ok('io-blocking-function.pl');

open $stdin, '<', \$input;
ok(perl::net::GetName() eq $input, "GetName should return ". $input );

close $stdin;

done_testing();
