#!/usr/bin/perl
use warnings; use strict;
use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Transport::SMTP;
use Getopt::Std;

my $opts = {};
getopts("dt:", $opts);
my $debug = $opts->{"d"};
my $rcpt = $opts->{"t"};
die "bad args\n" unless defined $rcpt;
chomp $rcpt;

my $mailhost = "";
my $user = "";
my $pass = "";

open CFG, "<", "email.cfg" or die $!;
$user = <CFG>;
$pass = <CFG>;
close CFG;

chomp $user;
chomp $pass;
my $hid = join "", (map{"*"} (split "", $pass));
if($user =~ /\@gmail\.com$/)
{
  $mailhost = "smtp.gmail.com";
}
elsif($user =~ /\@yahoo\.com$/)
{
  $mailhost = "smtp.mail.yahoo.com";
}
else
{
  die "only supports gmail and yahoo\n";
}

if($debug) #if undefined, evaluates to false
{  print "fr:$user\npw:$hid\nto:$rcpt\n";}

my $transport = Email::Sender::Transport::SMTP->new(
  host => $mailhost,
  port => 465,
  ssl => "ssl",
  sasl_username => $user,
  sasl_password => $pass,
  debug => $debug
  );

my $msg = Email::Simple->create(
  header => [
    To => $rcpt,
    From => $user,
    Subject => "Simple Email from Perl"
    ],
  body => "Hungry? Eat a snickers"
  );

sendmail($msg, { transport => $transport });

