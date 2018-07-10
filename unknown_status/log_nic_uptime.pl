#!/usr/bin/perl

use warnings;
use strict;

#keep a log of network card uptimes

if($#ARGV > -1 && $ARGV[0] =~ /-h/)
{
    print "Keeps a log of the uptime of eth0 network interface card\n";
    print "\nUses a signal handle to catch SIGINT (Ctrl-C)\n";
    print "catches null or empty strings\n";
}

my $date;
my $turn_on_time;
my $turn_off_time;
my $delta_time;
my $lines;
my $seconds1;
my $seconds2;
my $filename;

$date = `date +%x_%X`;

$date =~ s/\s/_/;
$date =~ s/:/-/;
$date =~ s/\//-/;

chomp $date;

$filename = "nic_uptime_$date.log";

$SIG{'INT'} = 'INT_handler';

open LOG, ">jellal.txt" or die("couldn't open file. error: $!\n");

$seconds1 = 0;
$seconds2 = 0;

while(1)
{
    sleep 1;
    $seconds1++;
    $seconds2++:
    
    $lines = `ifconfig eth0`;
    if($lines !~ /error/)
    {
        if($lines =~ /inet/ && $lines =~ /UP/)
        {
            #checks if null or empty
            if(!(defined $turn_on_time && length $turn_on_time))
            {
                $turn_on_time = `date`;
                print LOG "eth0 turned on at $turn_on_time\n";
            }
        }
        else
        {
            #checks if null or empty
            if(!(defined $turn_off_time && length $turn_off_time))
            {
                $turn_off_time = `date`;
                $delta_time = $seconds1 / 60;
                $seconds1 = 0;
                print LOG "ran eth0 for $delta_time minutes\n";
                print LOG "eth0 turned off at $turn_on_time\n";
            }
        }
    }

    $lines = `ifconfig eth1`;
    if($lines !~ /error/)
    {
        if($lines =~ /inet/ && $lines =~ /UP/)
        {
            #checks if null or empty
            if(!(defined $turn_on_time && length $turn_on_time))
            {
                $turn_on_time = `date`;
                print LOG "eth1 turned on at $turn_on_time\n";
            }
        }
        else
        {
            #checks if null or empty
            if(!(defined $turn_off_time && length $turn_off_time))
            {
                $turn_off_time = `date`;
                $delta_time = $seconds2 / 60;
                $seconds2 = 0;
                print LOG "ran eth1 for $delta_time minutes\n";
                print LOG "eth1 turned off at $turn_off_time\n";
            }
        }
    }
}

sub INT_handler
{
    $date = `date`;
    print LOG "log closed at $date\n";
    close LOG;
    $turn_on_time = undef;
    exit(0);
}