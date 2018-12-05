#!/usr/bin/perl
use strict; use warnings;

use Getopt::Long;
use Email::Send::SMTP::Gmail;

my $password = "";
my $from = "";
my $to = "";
my $file = "";
die "bad args\n" unless scalar(@ARGV) == 4;
GetOptions("to=s" => \$to, "file=s" => \$file) or die "bad args\n";

open CFG, "email.cfg" or die $!;
$from = <CFG>;
$password = <CFG>;
close CFG;

chomp $from;
chomp $password;

my ($mail) = Email::Send::SMTP::Gmail->new(
    -login=>$from,
    -pass=>$password);

my $subj = "Perl Gmail Attachment Test";
my $body = "Can you find Waldo Butters?";

$mail->send(-to=>$to, -from=>$from,
  -subject=>$subj, -body=>$body,
  -attachments=>$file);

$mail->bye;
