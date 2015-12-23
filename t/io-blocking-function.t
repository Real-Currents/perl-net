#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use Test::More;# 'no_plan';
use Fcntl;

use IO::Handle;

# Create handle to mock STDIN input
my $stdin;
open $stdin, '<', \"John";

local *STDIN = $stdin unless(-p STDIN );
#print "Input: ". STDIN->getline() ."\n";
require_ok('io-blocking-function.pl');

close $stdin;

done_testing();
