#!/usr/bin/perl
use strict; use warnings;
use Email::Stuffer;
use Getopt::Long;

my $mime_msg = Email::Stuffer->new;
