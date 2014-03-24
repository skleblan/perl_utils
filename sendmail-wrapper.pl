#!/usr/bin/perl

use strict;
use warnings;

my $temp;
my @lines_out;
my @temp_lines;

if($#ARGV > -1 && $ARGV[0] =~ /-h/)
{
    print "this is the help message\n";
}

push @lines_out, "From: no-reply\@post.net\n";

print STDOUT "enter destination address:\n";
$temp = <STDIN>;
chomp $temp;
push @lines_out, "To: $temp\n";

push @lines_out, "Subject: Automatic E-mail\n";
push @lines_out, "MIME-Version: 1.0\n";
push @lines_out, "Content-Type: text/plain\n";
push @lines_out, "\n";

#set up comments for message file
$temp = "\n".
        "#lines beginning with an ampersand are comments and\n".
        "#will not be printed\n".
        "#\n".
        "# 1. Edit this file\n".
        "# 2. Save the file\n".
        "# 3. Quit\n";
open TEMPFILE, ">/tmp/sendmail-wrapper.usrmsg";
print TEMPFILE $temp;
close TEMPFILE;

#execute vim
system "vim /tmp/sendmail-wrapper.usrmsg";

#grab message
open FINISHEDFILE, "/tmp/sendmail-wrapper.usrmsg";
@temp_lines = <FINISHEDFILE>;
close FINISHEDFILE;

#parse message
for(my $i = 0; $i <= $#temp_lines; $i++)
{
    $temp = $temp_lines[$i];

    if($temp !~ /^#/)
    {
	chomp $temp;
        push @lines_out, "$temp\n";
    }
}

open OUTFILE, ">/tmp/sendmail-wrapper.outmsg";
print OUTFILE @lines_out;
close OUTFILE;

print "sending message. this may take a few minutes\n";
system "sendmail -i -t </tmp/sendmail-wrapper.outmsg";
#-i stands for ignore as in ignore the period
#usually used when sending a pre-written file

print "sent message\n";
