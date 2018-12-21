#!/usr/bin/perl

use strict;
use warnings;

my $temp;
my $sending_email_address = "no-reply\@hotmail.com";
my $recipient_email_address;
my $message_file;
my $force = 0;
my $response;
my @lines_out;
my @temp_lines;

my @whereis_lines;
my $whereis_text;

#TODO: need to make sure that sendmail is install and running

open WHEREISPIPE, "whereis sendmail |";
@whereis_lines = <WHEREISPIPE>;
close WHEREISPIPE;
$whereis_text = join(" ", @whereis_lines);
$whereis_text =~ s/^sendmail:\s?//;
chomp($whereis_text);
if(length($whereis_text) == 0)
{
  print "Error: sendmail is not installed on this machine\n";
  exit(-1);
}

#TODO: delete temporary files after message has been sent

#################################
# PARSE ARGUMENTS IF ANY
#################################

for(my $i = 0; $i <= $#ARGV; $i++)
{
    #help
    if($ARGV[$i] =~ /-h/)
    {
        printhelp();
        exit(0);
    }
    #force
    elsif($ARGV[$i] =~ /-f/)
    {
        $force = 1;
    }
    #to <email addr>
    elsif($ARGV[$i] =~ /-t/ && $#ARGV > $i)
    {
        $i++;
        $recipient_email_address = $ARGV[$i];
    }
    #message file
    elsif($ARGV[$i] =~ /-m/ && $#ARGV > $i)
    {
        $i++;
        $message_file = $ARGV[$i];
    }
    #unknown
    else
    {
        print "Unknown arguments. Use -h to learn acceptable arguments\n";
        exit(-1);
    }
}

#################################
# SETUP EMAIL HEADER
#################################

push @lines_out, "From: $sending_email_address\n";

#was an address passed in as a parameter?
if(!(defined($recipient_email_address) && length($recipient_email_address) > 0))
{
    print STDOUT "enter destination address:\n";
    $temp = <STDIN>;
    chomp $temp;
    push @lines_out, "To: $temp\n";
}
else
{
    push @lines_out, "To: $recipient_email_address\n";
}

push @lines_out, "Subject: Automatic E-mail\n";
push @lines_out, "MIME-Version: 1.0\n";
push @lines_out, "Content-Type: text/plain\n";
push @lines_out, "\n";

#################################
# SETUP MAIN MESSAGE
#################################

#was a message file passed in as a paramater?
if(!(defined($message_file) && length($message_file) > 0))
{
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

    #open message
    open FINISHEDFILE, "/tmp/sendmail-wrapper.usrmsg";
}
else
{
    #open what was passed in as an argument
    open FINISHEDFILE, $message_file;
}

#grab message
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

#################################
# CREATE TEMP FILE TO SEND
#################################

open OUTFILE, ">/tmp/sendmail-wrapper.outmsg";
print OUTFILE @lines_out;
close OUTFILE;

#do we skip the confirmation check?
if(!$force)
{
    print "message ready to send. do you want to continue? (y/n):";
    $response = <STDIN>;
    if($response =~ /[Nn]/)
    {
        print "exiting.  message not sent\n";
        exit(0);
    }
}

print "sending message. this may take a few minutes\n";
system "sendmail -i -t </tmp/sendmail-wrapper.outmsg";
#-i stands for ignore as in ignore the period
#usually used when sending a pre-written file

print "sent message\n";
exit(0);

############################################################
# subroutine
#
# prints the help message
#
# no arguments and no returns
############################################################
sub printhelp
{
    print "\n$0\n\tsteps through the process of using sendmail on outgoing messages\n\n";
    
    print "Usage: \n\t$0 [-h] [-f] [-t <dest addr>] [-m <msg file>]\n\n\n";
    
    print "If no arguments are passed in, the program will prompt the user ";
    print "for all of the necessary details.  The program defaults the ";
    print "sending email address to be $sending_email_address.r  The program ";
    print "will set the subject to \"Automatic E-mail\".\n\n\n";
    
    print "-t <dest address> - pass in a destination address (the -t stands ";
    print "for the TO field)\n";
    print "-m <message file> - pre-existing message file that will be sent (";
    print "the -m stands for the MESSAGE field)\n";
    print "-f                - Force option. Will skip the final confirmation ";
    print "that's prompted just before the message is sent\n";
    print "-h                - Display help message and exit\n\n";
    
    print "Made by Steven Keller LeBlanc. 2014.\n";
    print "\n";
    return;
}
