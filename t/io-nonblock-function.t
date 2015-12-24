#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Test::More::Behaviour;
use Fcntl;

use IO::Handle;

# Create handle to mock STDIN input
my( $input, 
    $stdin ) = (
        (-p STDIN )? STDIN->getline() : "John",
        new IO::Handle()
    );
local *STDIN = $stdin;
open $stdin, '<', \$input;
print "Input: ". STDIN->getline() ."\n";

describe 'A non-blocking io function' =>  sub {
    it "should not block native thread from processing more executable code" => sub {
        open $stdin, '<', \$input;
        require_ok('io-nonblock-function.pl');
    };
};

open $stdin, '<', \$input;
ok(perl::net::GetName() eq $input, "GetName should return ". $input );

close $stdin;

done_testing();
