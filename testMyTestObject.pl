#/usr/bin/perl

use MyTestObject;

my $uut = MyTesObject->new;

print $uut->getinteger." default\n";

$uut->setinteger(45);
print "new value is ".$uut->getinteger."\n";

