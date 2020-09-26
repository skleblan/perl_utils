#!/usr/bin/env perl
#===============================================================================
#
#         FILE: check_images.pl
#
#        USAGE: ./check_images.pl  
#
#  DESCRIPTION: 
#
#===============================================================================

use strict;
use warnings;
use utf8;
use imgchk;

die "Need 2 filenames as args" unless $#ARGV >= 1;
my ($file1, $file2) = @ARGV;

if(imgchk::is_same($file1, $file2))
{
  print "$file1 and $file2 are similar\n";
}
else
{
  print "no match\n";
}
