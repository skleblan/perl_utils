#!/usr/bin/perl

use strict;
use warnings;

my ($from, $to, $subject, $shown);
my ($plain_pass, $hash_pass, $hash_from);
my (@header_lines, @data_lines, @temp_lines);
my $mailserver = "smtp.gmail.com";
my $portnumber = 465;

#check for -h
if( $#ARGV > -1 && $ARGV[0] =~ /-h/ )
{
    print "this program will provide interactive prompts to send an email via raw smtp\n";
    exit(0);
}

#get from
print "enter your email address (FROM): yellowcarpetmen\@gmail.com\n";
#$from = <STDIN>;
#chomp $from;
$from = "yellowcarpetmen\@gmail.com";
$hash_from = encode_base64($from);

#get password
print "enter the password for $from: ";
$plain_pass = <STDIN>;
chomp $plain_pass;
$hash_pass = encode_base64($plain_pass);

#get to
print "enter the recipient's email address (TO): skleblan\@gmail.com\n";
#$to = <STDIN>;
#chomp $to;
$to = "skleblan\@gmail.com";

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

open WRITENC, ">./smtp-wrapper.tmplog";

pipe READNC, WRITENC, "openssl s_client -connect $mailserver:$portnumber -crlf\n" or die("couldn't open the openssl s_client to $mailserver on $portnumber\n");

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
    die("error after saying HELO from $mailserver on port $portnumber:\n$response\n");
    }

print "authenticating\n";

print WRITENC "AUTH LOGIN\n";
$response = <READNC>;
chomp $response;
if($response !~ /^3\d\d/ ) #expecting a 300-code after this request
    {
    die("error after saying AUTH LOGIN from $mailserver on port $portnumber:\n$response\n");
    }

print "entering $hash_from as username $from\n";

print WRITENC $hash_from."\n";
$response = <READNC>;
chomp $response;
if($response !~ /^3\d\d/ ) #expecting a 300-code after this request
{
    die("error after entering username from $mailserver on $portnumber:\n$response\n");
}

print "entering password\n";

print WRITENC $hash_pass."\n";
$response = <READNC>;
chomp $response;
if($response !~ /^2\d\d/ ) #not sure if i'm expecting 200 or 300
{
    die("error after entering password from $mailserver on $portnumber:\n$response\n");
}

print "specifying who is sending the mail\n";

#send "from"
print WRITENC "MAIL FROM:<$from>\n";
$response = <READNC>;
chomp $response;
if($response !~ /^2\d\d/ )
    {
    die("error after saying MAIL FROM from $mailserver on port $portnumber:\n$response\n");
    }

print "writing source email address\n";

#send "to"
print WRITENC "RCPT TO:<$to>\n";
$response = <READNC>;
chomp $response;
if($response !~ /^2\d\d/ )
    {
    die("error after saying RCPT TO from $mailserver on port $portnumber:\n$response\n");
    }

print "writing destination email address\n";

#send data cmd
print WRITENC "DATA\n";
$response = <READNC>;
chomp $response;
if($response !~ /^[23]\d\d/ )
    {
    die("error after saying DATA from $mailserver on port $portnumber:\n$response\n");
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
    die("error after posing a period from $mailserver on port $portnumber:\n$response\n");
    }

print "data message successfully sent\n";

#send quit command
print WRITENC "QUIT\n";
$response = <READNC>;
chomp $response;
if($response !~ /^2\d\d/ )
    {
    die("error after sending QUIT from $mailserver on port $portnumber:\n$response\n");
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
