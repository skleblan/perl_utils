#!/usr/bin/perl

#program to try and not use `` to get input from system command

#if nothing is done, system() will print output to stdout

use warnings;
use strict;

my $cmd = "uptime";
my $input;

# set up pipe to send command (uptime) to handle MYHANDLE
open MYHANDLE, "$cmd|";

# execute the command as a placebo
# output sent to terminal. doesn't make it through here
system $cmd;

# execute the command as the test
# output comes through this script and is used
$input = <MYHANDLE>;

chomp($input);

# print results of the test
print "booga booga:$input\n";
print "did it work?\n";

exit(0);
