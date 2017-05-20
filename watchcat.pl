#!/usr/bin/perl

$logpath = "litterbox";
$signal = "INT";
$datetime = `date`;
chomp $datetime;
$this_file = $0;
#$this_file = split( $this_file, "\/");
$seconds = 30;
$user = $ENV{"LOGNAME"};

$SIG{$signal} = \&feeding;

if($#ARGV >= 0)
{
  $arg = shift;
  if($arg =~ /feed/)
  {
    @results = `ps -ef`;
    print "searching for $this_file\n";
    foreach $line (@results)
    {
      if($line =~ /perl.+$this_file/ && $line !~ /feed/)
      {
        print $line;
        if($line =~ /^\w+\s+(\d+)/)
        {
          print "pid is $1\n";
          system("kill -INT $1");
        }
        else
        {
          print "error getting pid from\n-->$line\n";
        }
      }
    }
    print "finished feeding\n";
  }
  else
  {
    exit(-1);
  }
}
else
{
  sleep $seconds;

  $tty = $ENV{"SSH_TTY"};
  chomp $tty;

  if(length($tty) > 0)
  {
    open LOGFILE, ">>$logpath" or die("can't open log");
    print LOGFILE "$user kicked off $datetime on $tty\n";
    close LOGFILE;

    print "\nyou did not feed the cat.\nyou have been kicked off\n";

    $tty =~ s/^.dev.//;

    open PS_GREP_PROC, "ps -ef | grep sshd |";
    @ps_grep_lines = <PS_GREP_PROC>;
    close PS_GREP_PROC;

    foreach (@ps_grep_lines)
    {
      if( $_ =~ /^$user\s+(\d+).*sshd.*$user\@$tty.*/ )
      {
        system("kill $1");
        break;
      }
    }
  }
}

sub feeding
{
  $datetime = `date`;
  open LOGFILE, ">>$logpath" or die("can't open log");
  print LOGFILE "$user fed cat at $datetime\n";
  close LOGFILE;

  print "\nThe cat has been fed\n";
  exit(0);
}
