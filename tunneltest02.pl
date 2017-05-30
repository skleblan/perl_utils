#!/usr/bin/perl

use warnings;
use strict;

use Net::OpenSSH;

my $host = "bravo";
my $key_path = $ENV{"HOME"}."/.ssh/id_rsa";

my $ssh = Net::OpenSSH->new($host, key_path=>$key_path, master_ops=>[-o=>"RemoteForward 22222 sdf.org:22"]);
$ssh->error and die "Couldn't establish SSH connection. ".$ssh->error;

while(1){}
