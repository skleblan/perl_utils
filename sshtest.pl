#!/usr/bin/perl

use warnings;
use strict;

use Net::SSH::Perl;

die "ssh.pass does not exist\n" if(! -e "ssh.pass");

my $server = "localhost";
my $port = "22";
my $username = "steven";
my $password = `cat ssh.pass`;
my $command = "df -h";

print "init complete\n";

my $ssh = Net::SSH::Perl->new($server, port=>$port);

print "setup ssh object\n";

$ssh->login($username, $password);

print "logged in\n";
my ($stdout, $stderr, $exit) = $ssh->cmd($command);

print "command has been executed\n";

print $stdout;
