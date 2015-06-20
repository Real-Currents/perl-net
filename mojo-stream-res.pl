#!/usr/bin/env perl
use 5.10.1;
use strict;
use warnings;

# Receiving a streaming response
use Mojo::UserAgent;

# Build a normal transaction
my $ua = Mojo::UserAgent->new;
my $tx = $ua->build_tx(GET => shift) or die "$!";

# Accept response of indefinite size
$tx->res->max_message_size(0);

# Replace "read" events to disable default content parser
$tx->res->content->unsubscribe('read')->on(read => sub {
  my ($content, $bytes) = @_;
  say "Streaming: $bytes";
});

# Process transaction
$tx = $ua->start($tx);
