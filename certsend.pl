#!/usr/bin/perl
use strict; use warnings;
use FindBin qw($RealBin);
use Getopt::Long;
use Email::Send::SMTP::Gmail;

my $password = "";
my $from = "";
my $to = "";
my $file = "";
die "bad args\n" unless scalar(@ARGV) == 2;
GetOptions("file=s" => \$file) or die "bad args\n";

open CFG, "$RealBin/email.cfg" or die $!;
$from = <CFG>;
$password = <CFG>;
close CFG;

open CERTCFG, "$RealBin/certsend.cfg" or die $!;
$to = <CERTCFG>;
close CERTCFG;

chomp $from;
chomp $password;
chomp $to;

my ($mail) = Email::Send::SMTP::Gmail->new(
    -login=>$from,
    -pass=>$password);

my $subj = "iPhone cert test";
my $body = "Please check this root certificate on your iPhone.\n";

$mail->send(-to=>$to, -from=>$from,
  -subject=>$subj, -body=>$body,
  -attachments=>$file);

$mail->bye;
