#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Message Digest
use Digest::MD5;
use IO::File;

my $md5 = new Digest::MD5;
my $file = shift || 'hosts.txt';
my $fh = IO::File->new($file);

#$md5->add($data);
$md5->addfile($fh);

print $md5->digest ."\n";
print $md5->b64digest ."\n";
print $md5->hexdigest ."\n";
