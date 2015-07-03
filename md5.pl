#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Message Digest
use Digest::MD5;
use IO::File;

my $md5 = Digest::MD5->new;
my $file = shift || 'hosts.txt';
my $fh = IO::File->new($file);

$md5->add("foobarbaz");
print unpack('H*', $md5->digest) ."\n";

$md5->add("foobarbaz");
print $md5->hexdigest ."\n";

$md5->add("foobarbaz");
print $md5->b64digest ."\n";

Digest::MD5->new->addfile($fh) or die "$! \n";
print unpack('H*', $md5->digest) ."\n";

Digest::MD5->new->addfile($fh) or die "$! \n";
print $md5->hexdigest ."\n";

Digest::MD5->new->addfile($fh) or die "$! \n";
print $md5->b64digest ."\n";
