#!/usr/bin/perl

use warnings;
use strict;

use Image::ExifTool qw(:Public);
use Data::Dumper;
use File::Spec;
use Cwd ();

die "requires a path as an argument\n" unless scalar(@ARGV)>0;
my $path = shift @ARGV;
die "path doesnt exist\n" unless -e $path;
die "path is not a directory\n" unless -d $path;

my $outfile = "exif.csv";
my $masterfile = 1;

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
          'AudioFormat',
          '__dir__'
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
  my $curdir_file_tag_list = [];
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
 
  if(not $masterfile)
  {
    open OUTH, ">$outfile" or die $!;

    print OUTH join(",", @mytaglist); #headers
    print OUTH "\r\n";
  }
 
  foreach (@diritems)
  {
    next unless $_ ne ".." and $_ ne ".";
    if(-d $_)
    {
      print $_." dir\n";
      my $sub_lol = iteratedir($_);
      push @$curdir_file_tag_list, @$sub_lol;
      next;
    }
    next if not -f $_;
    next if $_ =~ /.+\.txt$/;
    next if $_ =~ /.+\.csv$/;
    #print "processing $_\n";
    my $taglist = ImageInfo($_);
    filterdesiredtags($taglist);
    $taglist->{'__dir__'} = Cwd::cwd;
    my @vals = ();
    foreach my $t (@mytaglist)
    {
      if(defined $taglist->{$t})
      {
        $taglist->{$t} =~ s/,//;
        push @vals, $taglist->{$t};
      }
      else { push @vals, "__undefined__"; }
    }
    my $tempstr = join(",", @vals);
    push @$curdir_file_tag_list, \@vals;
    if(not $masterfile)
    {
      print OUTH $tempstr."\r\n";
    }
  }

  if(not $masterfile)
  {
    close OUTH;
  }
  print "changing to $oldpath\n";
  chdir $oldpath;

  return $curdir_file_tag_list;
}

my $total_lol = iteratedir($path);

if($masterfile)
{
  my $fullpath = File::Spec->catfile($path, $outfile);
  open MASTER, ">$fullpath" or die $!;
  print MASTER join(",", @mytaglist)."\r\n";

  foreach my $big (@$total_lol)
  {
    my $tempstr = join(",", @$big);
    print MASTER $tempstr."\r\n";
  }

  close MASTER;
}
