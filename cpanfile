#!/usr/bin/env perl
#$ cpanm --installdeps [--sudo] .

requires 'Socket', '2.019';
requires 'IO::Handle', '1.28';
requires 'IO::File', '1.14';
requires 'File::Monitor', '1.00';
requires 'AnyEvent', '7.09';
requires 'AnyEvent::HTTP', '2.22';
