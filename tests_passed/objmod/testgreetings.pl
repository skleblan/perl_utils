#!/usr/bin/perl

use Greetings;
#if module is in the same direction then
#no special include directives are needed
#perl can automatically pick them up

$mystring = english();

print $mystring;
print $mystring;

$mystring = spanish();
print $mystring;

exit(0);
