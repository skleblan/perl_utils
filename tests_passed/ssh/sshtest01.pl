#!/usr/bin/perl

use warnings;
use strict;

use Net::SSH::Perl;

die "ssh.pass does not exist\n" if(! -e "ssh.pass");

my $server = "localhost";
my $port = "22";
my $username = "steven";
my $password = `cat ssh.pass`;
chomp $password;
my $command = "df -h";

print "init complete\n";
#print "password is \"$password\"\n";

#specify an empty array REFERENCE to dis-allow pub-key auth.
my $ssh = Net::SSH::Perl->new($server, port=>$port, identity_files=>[]);

#debug=>1 turns on debug messages

#did not work for stopping Public Key Authentication, but useful to have
#options=>["PubkeyAuthentication=no", "PreferredAuthentications=keyboard-interactive,password"]);

print "setup ssh object\n";

$ssh->login($username, $password);

print "logged in\n";
my ($stdout, $stderr, $exit) = $ssh->cmd($command);

print "command has been executed\n";

print $stdout;
