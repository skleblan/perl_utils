#!/usr/bin/perl

use MyScratchObject;

my $uut = MyScratchObject->new;

print $uut->getinteger." default\n";

$uut->setinteger(45);
print "new value is ".$uut->getinteger."\n";

