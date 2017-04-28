#!/usr/bin/perl
use Net::OpenSSH;

my $host = "bravo";
my $key_path = "/home/steven/.ssh/id_rsa";

my $ssh = Net::OpenSSH->new($host, key_path=>$key_path);
$ssh->error and die "Couldn't establish SSH connection: ".$ssh->error;

my @pwd = $ssh->capture("pwd");
$ssh->error and die "remote pwd command failed: ".$ssh->error;

print "result of pwd on bravo:\n";
foreach (@pwd)
{
    print $_."\n";
}
