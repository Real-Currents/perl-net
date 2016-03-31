#!/usr/bin/env perl
use 5.20.2;
use strict;
use warnings;

use feature qw(postderef);

use Attribute::Handlers;

# A tutorial on perl attributes
sub foo : method ;

sub Bent : ATTR(SCALAR) {
    my ($package, $symbol, $referent, $attr, $data) = @_;
    print "Bent called with $package, $symbol, $referent, $attr, $
+data\n";
}

my ($x,@y,%z) : Bent = 1;

my $s = sub : method { ... };

my @attrlist;

use attributes ();    # optional, to get subroutine declarations
@attrlist = attributes::get(\&foo);

use attributes 'get'; # import the attributes::get subroutine
@attrlist = get \&foo;
