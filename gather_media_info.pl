#!/usr/bin/perl

use warnings;
use strict;

use Image::ExifTool qw(:Public);
use Data::Dumper;

die "requires a path as an argument\n" unless scalar(@ARGV)>0;
my $path = shift @ARGV;
die "path doesnt exist\n" unless -e $path;
die "path is not a directory\n" unless -d $path;

my @desiredtaglist = (
          'FileName',
          'FileSize',
          'FileType',
          'FileTypeExtension',
          'MIMEType',
          'ImageWidth',
          'ImageHeight',
          'ImageSize',
          'VideoFrameRate',
          'TrackDuration',
          'MediaDuration',
          'Duration',
          'AudioFormat'
);
chdir $path;

opendir DIRH, ".";
my @diritems;
my $temp;
while($temp = readdir DIRH)
{
  push @diritems, $temp;
}
closedir DIRH;

sub filterdesiredtags
{
  my $hashref = shift;
  die "not ref to a hash" unless ref $hashref;
  foreach my $k (keys(%$hashref))
  {
    my $save = (scalar( grep { $k eq $_ } @desiredtaglist ) > 0);

    next if ($save);
 
    delete $hashref->{$_};
  }
}

my $outfile = "exif.csv";

open OUTH, ">$outfile" or die $!;

foreach (@diritems)
{
  next if not -f $_;
  next if $_ =~ /.+\.txt$/;
  my $taglist = ImageInfo($_);
  filterdesiredtags($taglist);
  my $tempstr;# = Dumper($taglist);
  $tempstr = join(",", map { $taglist->{$_}; } @desiredtaglist);
  print OUTH $tempstr."\r\n";
}

close OUTH;
