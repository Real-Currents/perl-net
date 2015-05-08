#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

package Debugger;
use Errno qw(:POSIX);

sub error( $ );

sub error( $ ) {
	my $e = shift;
	
	if( $e == EACCES ) { 
		warn "You do not have permission to open this file.\n";
	} elsif( $e == ENOENT ) {
		warn "File or directory not found.\n";
	} else {
		warn "Some other error occurred: $e \n";
	}
	
	exit 0;
}

1;
