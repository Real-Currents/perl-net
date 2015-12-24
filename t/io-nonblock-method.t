#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Test::More::Behaviour;

use AnyEvent;
use IO::Handle;

sub concurrentExeCode;
my $aeTimer = AE::timer( 1, 0, \&concurrentExeCode);

# Create handle to mock STDIN input
my( $input, 
    $stdin ) = (
        (-p STDIN )? STDIN->getline() : "John",
        new IO::Handle()
    );
local *STDIN = $stdin;
open $stdin, '<', \$input;
print "Input: ". STDIN->getline() ."\n";

ok($aeTimer, "should create timer with AE");

describe 'A non-blocking io function' =>  sub {
    it "should allow native thread to concurrently process executable code" => sub {
        open $stdin, '<', \$input;
        require_ok('io-nonblock-method.pl');
    };
};

sub concurrentExeCode {
    open $stdin, '<', \$input;
    perl::net::GetName();
}

close $stdin;

done_testing();
