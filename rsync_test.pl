#!/usr/bin/perl
use warnings;
use strict;

#create test sandbox
my $rootdir = $ENV{"HOME"}."/rsyncsandbox";
#my $pathtoroot = $ENV{"PWD"};

chdir $ENV{"HOME"};

if(not -e $rootdir)
{
  mkdir $rootdir;
}
die "cannot create sandbox root directory\n" unless -d $rootdir;
chdir $rootdir;


&run_test_01();


exit(0);

sub run_test_01
{
  my $test_dir_src = "test_01_1_src";
  my $test_dir_dest = "test_01_2_dest";
  mkdir $test_dir_src unless -e $test_dir_src;
  mkdir $test_dir_dest unless -e $test_dir_dest;

  chdir $test_dir_src;

  foreach("alpha", "bravo", "charlie")
  {
    system "echo $_ > $_.txt";
  }

  chdir $rootdir;
  #Currently, this copies the whole directory (including the dir itself)
  #into the destination.
  system("rsync -av $test_dir_src $test_dir_dest");
  #-a uses the archive option which is a combination of -r, -l, -p, -t,
  #    -g, -o, -D.  This is a very useful option
  #-v uses the verbose mode.
}
