#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

use IO::File;
require 'debugger.pl';

my $file = shift;
my $counter = 0;
my $fh = IO::File->new($file) or Debugger::error $!;

while( defined(my $line = $fh->getline) ) {
	$counter++;
}
STDOUT->print("Counted $counter\n");
close $fh or Debugger::error($!);
