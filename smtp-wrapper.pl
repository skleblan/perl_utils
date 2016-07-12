#!/usr/bin/perl

use strict;
use warnings;

my ($from, $to, $subject, $shown);
my (@header_lines, @data_lines, @temp_lines);
my $mailserver = "localhost";
my $portnumber = 25;

#check for -h
if( $#ARGV > -1 && $ARGV[0] =~ /-h/ )
{
    print "this program will provide interactive prompts to send an email via raw smtp\n";
    exit(0);
}

#get from
print "enter your email address (FROM):\n";
$from = <STDIN>;
chomp $from;

#get to
print "enter the recipient's email address (TO):\n";
$to = <STDIN>;
chomp $to;

#get subject
print "enter the subject of the email:\n";
$subject = <STDIN>;
chomp $subject;

#ask if these email addresses will be included in the message
print "do you want the TO and FROM email addresses to be shown? (y/n):";
$shown = <STDIN>;
chomp $shown;

#set up vim
open DATAFILE, ">/tmp/smtp-wrapper.datamsg";
print DATAFILE "\n";
print DATAFILE "#lines beginning with ampersands are comments and will not be included\n";
print DATAFILE "#\n";
print DATAFILE "# 1. Compose your message\n";
print DATAFILE "# 2. Save the message\n";
print DATAFILE "# 3. Quit vim\n";
close DATAFILE;

#open vim
system("vim /tmp/smtp-wrapper.datamsg");

#read data written to vim
open USERDATA, "/tmp/smtp-wrapper.datamsg";
@temp_lines = <USERDATA>;
close USERDATA;

#compile data
for(my $i = 0; $i <= $#temp_lines; $i++)
{
    my $temp;

    $temp = $temp_lines[$i];
    chomp $temp;
    if($temp !~ /^#/ )
    {
        push @data_lines, $temp;
    }
}

#connect to server
#########open WRITENC, ">/tmp/smtp-wrapper.tmplog";
#pipe READNC, WRITENC, "nc $mailserver $portnumber\n" 
#    or die("couldn't open netcat to $mailserver on port $portnumber\n");    

#------------------------------------
# not sure if i did the pipe correct
#------------------------------------
print "opening connection to $mailserver\n";

my $response = <READNC>;
chomp $response;
if($response !~ /^2\d\d/ )
    {
    die("error from $mailserver on port $portnumber:\n$response\n");
    }

print "connection opened successfully\n";

#send destination server
print WRITENC "HELO $mailserver\n";
$response = <READNC>;
chomp $response;
if($response !~ /^2\d\d/ )
    {
    die("error from $mailserver on port $portnumber:\n$response\n");
    }

print "specifying destination server\n";

#send "from"
print WRITENC "MAIL FROM:<$from>\n";
$response = <READNC>;
chomp $response;
if($response !~ /^2\d\d/ )
    {
    die("error from $mailserver on port $portnumber:\n$response\n");
    }

print "writing source email address\n";

#send "to"
print WRITENC "RCPT TO:<$to>\n";
$response = <READNC>;
chomp $response;
if($response !~ /^2\d\d/ )
    {
    die("error from $mailserver on port $portnumber:\n$response\n");
    }

print "writing destination email address\n";

#send data cmd
print WRITENC "DATA\n";
$response = <READNC>;
chomp $response;
if($response !~ /^[23]\d\d/ )
    {
    die("error from $mailserver on port $portnumber:\n$response\n");
    }

print "sent command to start sending data message\n";

#send data header
#to,from if desired
#put the date in
#put in subject
if($shown)
{
    push @header_lines, "From: <$from>\n";
    push @header_lines, "To: <$to>\n";
}
push @header_lines, "Subject: $subject\n";
push @header_lines, localtime()."\n";
push @header_lines, "\n";
print WRITENC @header_lines;

#enter message
print WRITENC @data_lines;

#enter a period on it's own line
print WRITENC ".\n";
$response = <READNC>;
chomp $response;
if($response !~ /^2\d\d/ )
    {
    die("error from $mailserver on port $portnumber:\n$response\n");
    }

print "data message successfully sent\n";

#send quit command
print WRITENC "QUIT\n";
$response = <READNC>;
chomp $response;
if($response !~ /^2\d\d/ )
    {
    die("error from $mailserver on port $portnumber:\n$response\n");
    }

print "sending quit command\n";

#final report back to user and delete temp files
$response = <READNC>;
chomp $response;
if($response !~ /^2\d\d/ )
    {
    die("error from $mailserver on port $portnumber:\n$response\n");
    }

close WRITENC;
close READNC;

#finished
