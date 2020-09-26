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
use Carp;

sub is_same
{
  my $file1 = shift;
  my $file2 = shift;

  my $retval = &_is_same_checksum($file1, $file2);

  if(not $retval)
  {
    $retval = &_is_same_phash($file1, $file2);
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
  return 0;
}

sub _is_same_sift
{
  return 0;
}

1;
