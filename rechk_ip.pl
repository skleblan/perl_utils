#!/usr/bin/perl

#made by steve leblanc

#program will run continuously and re-assert our ip-address

#uses string/array join and split
#receives POSIX signals
#uses Expect module for sudo authentication
#fork but no exec


my $i;
my $temp;
my @lines;
my $ip_address = "192.168.16.5";
#my @lines2;

if($#ARGV > -1 && $ARGV[0] =~ /-h/)
{
    print "starts up rechk_ip.pl and runs in background\n";
    print "\nperl concepts:\n====================\n";
    print "string:      split, join\n";
    print "signals:     ??\n";
    print "module:      expect.pm\n";
    print "system:      fork\n";
    exit(0);
}

#check apparent user id ($< is the real user id)
if($> != 0)
{
    print "needs to be ran as root\n";
    exit(-1);
}

if(fork() != 0)
{
    print "rechk_ip.pl has been started. use stp_rechk_ip.pl to stop.\n";
    exit(0);
}

while(1)
{

    #time delay
    for($i = 0; $i < 60*1000; $i++);

    $temp = `ifconfig`;
    @lines = split /[\n\r]+/, $temp;

    #try alternate method by accessing stdout or redirecting it here

    $temp = join '\n', @lines;

    if($temp =~ /inet\saddr:(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/)
    {
        $check = $1;
        if($check !~ /$ip_addr/)
        {
            system("ifconfig eth0 inet 192.168.16.5 netmask 255.255.255.0") or die("rechk_ip.pl error: $!\n");
        }
    }
    else
    {
        system("ifconfig eth0 inet 192.168.16.5 netmask 255.255.255.0") or die("rechk_ip.pl error: $!\n");
    }
    
}