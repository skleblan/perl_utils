#!/usr/bin/perl

use warnings;
use strict;

my $cmd = shift;

if($cmd =~ /start/)
{

  $SIG{"USR1"} = \&close_ssh;
  die "Error. SSH Agent is not running" if !is_running_ssh_agent();

  system("ssh -fNT -L 22222:skleblan.freeshell.org:80 bravo");
  while(1){}

  exit(-1);
}
elsif($cmd =~ /stop/)
{
  exit(-1);

  #TODO: finish implementation

  my @ps_lines;
  open PSPIPE, "ps -ef | grep $0 |";
  @ps_lines = <PSPIPE>;
  close PSPIPE;

  exit(0);
}

sub close_ssh
{
  exit(0);
}

sub is_running_ssh_agent
{
  my $check_cmd = "ssh-add -l";
  open AGENTPIPE, "$check_cmd|";
  my @lines_out = <AGENTPIPE>;
  close AGENTPIPE;

  foreach (@lines_out)
  {
    if ($_ =~ /Could\snot\sopen\sa\sconnection\sto\syour\sauthentication\sagent/)
    {
      return 0;
    }
    elsif ($_ =~ /The\sagent\shas\sno\sidentities/)
    {
      return 0;
    }
  }

  return 1;
}
