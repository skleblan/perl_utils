#!/usr/bin/perl

#program will kill all forms of a user on a system
#i.e. send kill commands to bash, tty, sshd session, etc

#no arguments should display output from cmd "w" augmented with extra data
#FIRST TASK ^^^

#should be able to specify users, terminals, or pids

#things to think about: killing someone else who is root?

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

my $cmd_choice;
my @killlist;

################################
# EXECUTE W CMD
################################

open WDATA, "w|";
@wlines = <WDATA>;
close WDATA;

print "\n";
print "boom\n";
print "splash\n";

#whatis splash

#################################
# COUNT NUMBER OF USERS
#################################

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

####################################
# CONSTRUCT NAME-TTY RELATIONSHIPS
####################################

print "$numusers users found\n";

#for each user, create data structure
for($i = 0; $i < $numusers; $i++)
{
    $temp1 = $wlines[$i+2];
    if($temp1 =~ /^(\w+)\s*([\w\/]+)/)#\s*:?\w?\s*(\d{,2}\w{3}\d\d?)\s*[\w:]*\s*[\w:]*\s*[\w:]*\s*(\w.*$)/)
    #regex => (beginning)-word-space-word
    {
        $userdata{'name'} = $1;
        $userdata{'tty'} = $2;
        #$userdata{'logondate'} = $3;
        #$userdata{'mnprog'} = $4;
        push @users, {%userdata};
        print "pushed...\n";
    }
}

#####################################
# POPULATE PROCESS LIST PER USER
##################################### 

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
        if($process =~ /\w+\s+(\d+)/) #regex => word-space-number
        {
            chomp($1);
            push @userpids, $1;
        }
    }
    
    $temp1->{'pidlist'} = [@userpids];
}

################################
# DETERMINE WHAT TTY THIS PROGRAM IS RUNNING ON
################################
open MYTTY, "tty |";
$mytty = <MYTTY>;
close MYTTY;
$mytty =~ s/^\/dev//; 

#can't literally have an array of hashes
#can have an array of references to hashes
#[] and {} are array and hash constructors respectively. they are guarunteed to allocate new memory

#########################
# PRINT OUT ALL USERS
#########################

print "Output from w\n";
print "====================\n";
for($i = 0; $i < $numusers; $i++)
{
    $temp2 = $users[$i];
    #for each element of the selected user
    foreach $key (keys (%$temp2))
    {
        #make sure it's not the pid list
        if($key !~ /pidlist/)
        {
            #print selected element
            print $temp2->{$key}.",";
        }
    }
    
    #if the terminal was the user's terminal (THIS terminal)
    if($temp2->{'tty'} =~ $mytty)
    {
        print "***";
    }
    
    print "\n";
    
    $temp1 = $temp2->{'pidlist'};
    #for each process belonging to this user
    foreach $process (@$temp1)
    {
        if(defined($process) && length($process))
        {
            print "\t";
            #print process name
            system("ps $process | grep $process");
        }
    }
    print "\n";
}

#########################
# SETUP COMMAND MENU
#########################

print "\nEnter a process number to kill a process.\n";
print "Enter a set of process numbers separated by spaces to kill those processes.\n";
print "Enter the tty path to kill all the processes with that tty.\n";
print "Enter \"user<name>\" to kill all processes and ttys under the user <name>.\n";
print "Enter \"allusers\" to kill all users (including yourself).\n";
print "Enter \"allothers\" to kill all users (except yourself).\n";
print "Enter \"q\" to quit and do nothing.\n";
print ":";

$cmd_choice = <STDIN>;

#########################
# Process sub-command
#########################

if($cmd_choice =~ /^\d+/) #regex => number
{
    print "killing processes $cmd_choice\n";
    ### TODO: program in some sort of semaphore or global variable to provide a check on forking
    &reliablekill( [ $cmd_choice ], 1);

}
elsif($cmd_choice =~ /^\/dev/)
{
    print "killing tty $cmd_choice\n";

}
elsif($cmd_choice =~ /^user(\w+)/)
{
    $cmd_choice =~ s/^user//;
    print "killing user $cmd_choice\n";

}
elsif($cmd_choice =~ /^allusers/)
{
    print "killing all users\n";

}
elsif($cmd_choice =~ /^allothers/)
{
    print "killing all other users\n";

}
#else q is for do nothing and quit

print "exiting...\n";

exit(0);

############################################################
# kill a list of processes passed in and make sure that
# they stay killed
#
# will only fork once for all pids
#
# arg0 - reference to array
# arg1 - size of array
############################################################
sub reliablekill
{
    my $i;
    my $childpid = 0;
    my @local_list;
    my @lines;
    my $list_ref = $_[0];
    my $size = $_[1];
    
    for($i = 0; $i < $size; $i++)
    {
        unshift @local_list, $list_ref->[$i];
        system("kill $local_list[0]");
    }
    
    #if child then fork returns 0
    #if parent then fork returns child id
    $childpid = fork();
    
    #return if parent
    if($childpid)
    {
        return;
    }
    else
    {
        sleep(5); #5 seconds
        
        for($i = 0; $i < $size; $i++)
        {
            open PIDCHECK, "ps $local_list[$i] |";
            @lines = <PIDCHECK>;
            close PIDCHECK;
            
            foreach (@lines)
            {
                if($_ =~ /$local_list[$i]/)
                {
                    system("kill -KILL $local_lise[$i]");
                }
            }#for all lines
        }#for all pids
        
        exit(0);
    }
    
    return;
            
}