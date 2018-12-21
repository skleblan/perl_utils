#!/usr/bin/perl
use warnings; use strict;
use Email::Sender::Simple qw(sendmail);
#use Email::Simple;
#use Email::Simple::Creator;
use Email::Sender::Transport::SMTP;
use Getopt::Std;
use MIME::Entity;

my $opts = {};
getopts("dt:f:", $opts);
my $debug = $opts->{"d"};
my $rcpt = $opts->{"t"};
my $file = $opts->{"f"};
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
{  print "fr:$user\npw:$hid\nto:$rcpt\nfile:$file\n";}

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
    Subject => "Simple MIME from Perl"
    ],
  body => "Hungry? Eat a Milky Way"
  );

my $mime = MIME::Entity->build(
  To => $rcpt,
  From => $user,
  Subject => "Simple MIME from Perl",
  Type => "multipart/mixed");

$mime->attach(Data => "Hungry? Eat a Milky Way",
  Type => "text/plain");
if(defined $file and -e $file)
{
  $mime->attach(Path => $file,
      Encoding => "base64",
      Disposition => "attachment");
}

sendmail($mime, { transport => $transport });

