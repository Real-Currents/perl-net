#!/usr/bin/env perl
use 5.10.1;
use warnings;
use strict;

use IO::Handle;

$| = 1;
STDOUT->print("Enter you name> ");

my $name = STDIN->getline();
STDOUT->print("Your name is $name") if( $name );

exit;
