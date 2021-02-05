#
#===============================================================================
#
#         FILE: imgchk.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 09/26/2020 11:49:20 AM
#     REVISION: ---
#===============================================================================

package imgchk;

use strict;
use warnings;
use Digest::MD5;
use Image::Hash;
use File::Slurp;
use GD;
use Carp;

sub is_same
{
  my $file1 = shift;
  my $file2 = shift;
  my $hash_size = 6;

  my $retval = &_is_same_checksum($file1, $file2);

  if(0)
  {
    $retval = &_is_same_ahash($file1, $file2, $hash_size);
  }

  if(0)
  {
    $retval = &_is_same_dhash($file1, $file2, $hash_size);
  }

  if(not $retval)
  {
    $retval = &_is_same_phash($file1, $file2, $hash_size);
  }

  if(not $retval)
  {
    $retval = &_is_same_sift($file1, $file2);
  }

  return $retval;
}

sub _is_same_checksum
{
  my $file1 = shift;
  my $file2 = shift;

  my $fh;
  open $fh, '<', $file1 or croak "Can't open $file1\n";
  binmode($fh);
  my $md51 = Digest::MD5->new->addfile($fh);
  my $digest1 = $md51->hexdigest;
  close $fh;

  open $fh, '<', $file2 or croak "Can't open $file2\n";
  binmode($fh);
  my $md52 = Digest::MD5->new->addfile($fh);
  my $digest2 = $md52->hexdigest;
  close $fh;

  return ($digest1 eq $digest2);
}

sub _is_same_phash
{
  my $file1 = shift;
  my $file2 = shift;
  my $size = shift;
  print "size is $size\n";

  my $img = read_file($file1, binmode => ':raw');
  my $ihash1 = Image::Hash->new($img, "GD");
  my $geometry = "".$size."x".$size;
  my $phash1 = $ihash1->phash('geometry' => $geometry);

  $img = read_file($file2, binmode => ':raw');
  my $ihash2 = Image::Hash->new($img, "GD");
  my $phash2 = $ihash2->phash('geometry' => $geometry);

  return ($phash1 eq $phash2);
}

sub _is_same_ahash
{
  my $file1 = shift;
  my $file2 = shift;
  my $size = shift;

  my $img = read_file($file1, binmode => ':raw');
  my $ihash1 = Image::Hash->new($img, "GD");
  my $geometry = "".$size."x".$size;
  my $ahash1 = $ihash1->ahash('geometry' => $geometry);

  $img = read_file($file2, binmode => ':raw');
  my $ihash2 = Image::Hash->new($img, "GD");
  my $ahash2 = $ihash2->ahash('geometry' => $geometry);

  return ($ahash1 eq $ahash2);
}

sub _is_same_dhash
{
  my $file1 = shift;
  my $file2 = shift;
  my $size = shift;

  my $img = read_file($file1, binmode => ':raw');
  my $ihash1 = Image::Hash->new($img, "GD");
  my $geometry = "".$size."x".$size;
  my $dhash1 = $ihash1->dhash('geometry' => $geometry);

  $img = read_file($file2, binmode => ':raw');
  my $ihash2 = Image::Hash->new($img, "GD");
  my $dhash2 = $ihash2->dhash('geometry' => $geometry);

  return ($dhash1 eq $dhash2);
}

sub _is_same_sift
{
  return 0;
}

1;
