#!/usr/local/bin/perl

use warnings;
use strict;

my $tmp_filename = "/tmp/ssmtp_temp_file.msg";
my $uptime;
my $line;
my @lines;
my $recipient;

if (not -e "config")
{
  die("Cannot find config file. Exiting");
}

open CONFIG, "<config";
@lines = <CONFIG>;
close CONFIG;
foreach $line (@lines)
{
  if($line !~ /^[#\s]/ && $line =~ /^email=(\S*)/)
  {
    $recipient = $1;
  }
}

print "recipient is $recipient\n";

if ($#ARGV == 0 && $ARGV[0] =~ /-auto/)
{
  open TMP_MSG, ">$tmp_filename" or die("can't create tmp file");

  print TMP_MSG "Subject: Auto BSD Email\n\n";
  print TMP_MSG "FreeBSD is running.\n";

  $uptime = `uptime`; #TODO: fix
  print TMP_MSG "Uptime is:\n\t$uptime\n";

  close TMP_MSG;

  system("ssmtp $recipient < $tmp_filename");

  system("rm $tmp_filename");
}
else
{
  die("no other options supported right now. you must use \"$0 -auto\" only.\n");
}

exit(0);
