#!/usr/bin/perl

#program to try and not use `` to get input from system command

#if nothing is done, system() will print output to stdout

use warnings;
use strict;

my $cmd = "uptime";
my $input;

print "before pipe\n";
#pipe STDOUT, MYHANDLE;
open MYHANDLE, "$cmd|";

system $cmd;
$input = <MYHANDLE>;

chomp($input);

print "booga booga:$input\n";
print "did it work?\n";

exit(0);