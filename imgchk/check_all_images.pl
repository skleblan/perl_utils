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
use Directory::Iterator;

die "Need 1 filename as arg" unless $#ARGV >= 0;
my $file1 = shift;
my $file2;

my $iter = Directory::Iterator->new("images");

while($file2 = $iter->next)
{
  next unless $file1 ne $file2;

  if(imgchk::is_same($file1, $file2))
  {
    print "$file1 and $file2 are similar\n";
  }
  
}
