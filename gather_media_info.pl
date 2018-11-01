#!/usr/bin/perl

use warnings;
use strict;

use Image::ExifTool qw(:Public);
use Data::Dumper;

die "requires a path as an argument\n" unless scalar(@ARGV)>0;
my $path = shift @ARGV;
die "path doesnt exist\n" unless -e $path;
die "path is not a directory\n" unless -d $path;

chdir $path;

opendir DIRH, ".";
my @diritems;
my $temp;
while($temp = readdir DIRH)
{
  push @diritems, $temp;
}
closedir DIRH;

open OUTH, ">exifresults.txt" or die $!;

foreach (@diritems)
{
  next if not -f $_;
  next if $_ =~ /.+\.txt$/;
  my $taglist = ImageInfo($_);
  my $tempstr = Dumper($taglist);
  print OUTH $tempstr;
}

close OUTH;
