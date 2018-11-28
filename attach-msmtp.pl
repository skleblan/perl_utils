#!/usr/bin/perl
use strict; use warnings;
use Email::Stuffer;
use Getopt::Long;

my $to = "";
my $subj = "";
my $filepath = "";

GetOptions( "to=s" => \$to,
  "subj=s" => \$subj,
  "file=s" => \$filepath )
  or die "error parsing arguments\n";

die "bad email address\n" unless $to =~ /\w+\@\w+/;
die "no subject\n" unless length $subj > 0;
die "file doesnt exist\n" unless -e $filepath;
die "not a file\n" unless -f $filepath;

my $mime_msg = Email::Stuffer->new;
$mime_msg->to($to);
$mime_msg->subject($subj);
$mime_msg->attach_file($filepath);

my $tmpfile = "tmp.msg";
open TMP, ">$tmpfile";
print TMP $mime_msg->as_string;
close TMP;

(system ("msmtp -a gmail $to <$tmpfile") == 0)
  or die "problem sending message with msmtp: $?\n";
