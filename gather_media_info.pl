#!/usr/bin/perl

use warnings;
use strict;

use Image::ExifTool qw(:Public);
use Data::Dumper;
use Cwd ();

die "requires a path as an argument\n" unless scalar(@ARGV)>0;
my $path = shift @ARGV;
die "path doesnt exist\n" unless -e $path;
die "path is not a directory\n" unless -d $path;

my @mytaglist = (
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

sub filterdesiredtags
{
  my $hashref = shift;
  die "not ref to a hash" unless ref $hashref;
  foreach my $k (keys(%$hashref))
  {
    my $save = (scalar( grep { $k eq $_ } @mytaglist ) > 0);

    next if ($save);
 
    delete $hashref->{$_};
  }
}

sub iteratedir
{
  my $curdir = shift;
  die "not a directory\n" unless -d $curdir;
  my $oldpath = Cwd::cwd;
  print "changing to $curdir\n";
  chdir $curdir;
  opendir DIRH, "." or die $!;
  my @diritems;
  my $temp;
  while($temp = readdir DIRH)
  {
    push @diritems, $temp;
  }
  closedir DIRH;
 
  my $outfile = "exif.csv";
  open OUTH, ">$outfile" or die $!;
 
  foreach (@diritems)
  {
    next unless $_ ne ".." and $_ ne ".";
    if(-d $_)
    {
      print $_." dir\n";
      iteratedir($_);
      next;
    }
    next if not -f $_;
    next if $_ =~ /.+\.txt$/;
    next if $_ =~ /.+\.csv$/;
    #print "processing $_\n";
    my $taglist = ImageInfo($_);
    filterdesiredtags($taglist);
    my @vals = ();
    foreach my $t (@mytaglist)
    {
      if(defined $taglist->{$t})
      { push @vals, $taglist->{$t}; }
    }
    my $tempstr = join(",", @vals);
    print OUTH $tempstr."\r\n";
  }

  close OUTH;
  print "changing to $oldpath\n";
  chdir $oldpath;
}

iteratedir($path);
