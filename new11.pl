#!/usr/bin/perl

#program will kill all forms of a user on a system
#i.e. send kill commands to bash, tty, sshd session, etc

#no arguments should display output from cmd "w" augmented with extra data
#FIRST TASK ^^^

#should be able to specify users, terminals, or pids

use strict;
use warnings;

my @wlines;
my $temp1;
my $temp2;
my $temp3;
my $i;
my $key;
my @psttydata;
my $process;

my $numusers;
my @users;
my %userdata;
my @userpids;
my $mytty;

open WDATA, "w|";
@wlines = <WDATA>;
close WDATA;

print "\n";
print "boom\n";
print "splash\n";

#whatis splash

$numusers = 0;
for($i = 0; $i < scalar @wlines; $i++)
{
    if($wlines[$i] =~ /\d\d?:\d\d?:\d\d?.*(\d\d?)\susers,.*/)
    {
        $numusers = $1;
    }
}

####################
#check for screen (not necessarily here)
####################

print "$numusers users found\n";

for($i = 0; $i < $numusers; $i++)
{
    $temp1 = $wlines[$i+2];
    if($temp1 =~ /^(\w+)\s*([\w\/]+)/)#\s*:?\w?\s*(\d{,2}\w{3}\d\d?)\s*[\w:]*\s*[\w:]*\s*[\w:]*\s*(\w.*$)/)
    {
        $userdata{'name'} = $1;
        $userdata{'tty'} = $2;
        #$userdata{'logondate'} = $3;
        #$userdata{'mnprog'} = $4;
        push @users, {%userdata};
        print "pushed...\n";
    }
}

for($i = 0; $i < $numusers; $i++)
{
    $temp1 = $users[$i];
    $temp2 = $temp1->{'tty'};
    open PSTTYDATA, "ps -f -t $temp2 |";
    @psttydata = <PSTTYDATA>;
    close PSTTYDATA;
    
    @userpids = ();
    foreach $process (@psttydata)
    {
        if($process =~ /\w+\s+(\d+)/)
        {
            chomp($1);
            push @userpids, $1;
        }
    }
    
    $temp1->{'pidlist'} = [@userpids];
}

open MYTTY, "tty |";
$mytty = <MYTTY>;
close MYTTY;
$mytty =~ s/^\/dev//;


#can't literally have an array of hashes
#can have an array of references to hashes
#[] and {} are array and hash constructors respectively. they are guarunteed to allocate new memory

print "Output from w\n";
print "====================\n";
for($i = 0; $i < $numusers; $i++)
{
    $temp2 = $users[$i];
    foreach $key (keys (%$temp2))
    {
        if($key !~ /pidlist/)
        {
            print $temp2->{$key}.",";
        }
    }
    print "\n";
    
    $temp1 = $temp2->{'pidlist'};
    foreach $process (@$temp1)
    {
        if(defined($process) && length($process))
        {
            print "\t-$process\n";
        }
    }
}

exit(0);