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
&run_test_02();

#test un-recognized files in destination
&run_test_03();
&run_test_04();

&run_test_05();
#investigate --bwlimit for rsync

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

sub run_test_02
{
  my $test_dir_src = "test_02_1_src";
  my $test_dir_dest = "test_02_2_dest";
  mkdir $test_dir_src unless -e $test_dir_src;
  mkdir $test_dir_dest unless -e $test_dir_dest;

  chdir $test_dir_src;

  foreach("alpha", "bravo", "charlie")
  {
    system "echo $_ > $_.txt";
  }

  chdir $rootdir;
  #Currently, this copies the individual files to the destination without
  #the enclosing folder
  system("rsync -av $test_dir_src/ $test_dir_dest/");
}

sub run_test_03
{
  my $test_dir_src = "test_03_1_src";
  my $test_dir_dest = "test_03_2_dest";
  mkdir $test_dir_src unless -e $test_dir_src;
  mkdir $test_dir_dest unless -e $test_dir_dest;

  chdir $test_dir_src;

  foreach("alpha", "bravo", "charlie")
  {
    system "echo $_ > $_.txt";
  }
  chdir $rootdir;
  chdir $test_dir_dest;
  print "test 03: creating delta.txt in destination folder\n";
  system "echo delta > delta.txt";

  chdir $rootdir;
  #Currently, this copies the individual files to the destination without
  #the enclosing folder
  system("rsync -av $test_dir_src $test_dir_dest");
}

sub run_test_04
{
  my $test_dir_src = "test_04_1_src";
  my $test_dir_dest = "test_04_2_dest";
  mkdir $test_dir_src unless -e $test_dir_src;
  mkdir $test_dir_dest unless -e $test_dir_dest;

  chdir $test_dir_src;

  foreach("alpha", "bravo", "charlie")
  {
    system "echo $_ > $_.txt";
  }
  chdir $rootdir;
  chdir $test_dir_dest;
  print "test 03: creating delta.txt in destination folder\n";
  system "echo delta > delta.txt";

  chdir $rootdir;
  #Currently, this copies the individual files to the destination without
  #the enclosing folder
  system("rsync -av $test_dir_src/ $test_dir_dest/");
}

sub run_test_05
{
  my $srcdir = "test_05_1_src";
  my $destdir = "test_05_2_dest";
  mkdir $srcdir unless -e $srcdir;
  mkdir $destdir unless -e $destdir;

  chdir $srcdir;

  foreach("alpha", "bravo", "charlie")
  {
    system "echo $_ > $_.txt";
  }
  chmod 0, "alpha.txt";

  chdir $rootdir;

  my $retval = system("rsync -av $srcdir/ $destdir/");
  if( $retval != 0 )
  {
    my $retval01 = $retval >> 8;
    my $retval02 = $retval & 0x8f;
    my $errcode = $!;
    my $errmsg = $?;
    print "run_test_05\n";
    print "system retval $retval\n";
    print "  retval 01 $retval01\n";
    print "  retval 02 $retval02\n";
    print "exclamation $errcode\n";
    print "question $errmsg\n";
  }

}

sub get_system_err_code
{
  my $code = shift;
  #the code expected as input can be retieved
  #either from the system() return value
  #or from $? immediately after execution

  #shift over to get the return code of
  #the child process
  return $code >> 8;
}
