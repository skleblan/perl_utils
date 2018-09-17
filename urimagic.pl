#!/usr/bin/perl
use URI;
# https://en.m.wikipedia.org/wiki/McKinley_Tariff
# https://en.m.wikipedia.org/wiki/Nobel_Prize_in_Physics
# https://en.m.wikipedia.org/wiki/Europe
# https://en.m.wikipedia.org/wiki/Raid_(military)
# https://en.m.wikipedia.org/wiki/Draft_(hull)
# https://en.m.wikipedia.org/wiki/Panama_Canal
# https://en.wikipedia.org/wiki/Panama_Canal
# https://en.m.wikipedia.org/wiki/Coffee
# https://en.m.wikipedia.org/wiki/Iron_Man

$u1 = URI->new("http://www.perl.com");
$u2 = URI->new("foo", "http");
$u3 = $u2->abs($u1);

print "u1 $u1\n";
print "u2 $u2\n";
print "u3 $u3\n";

print "scheme u3 ".$u3->scheme."\n";
print "opaque u3 ".$u3->opaque."\n";
print "path u3 ".$u3->path."\n";
print "fragment u3 ".$u3->fragment."\n";
print "host u3 ".$u3->host."\n";

$u4 = URI->new("http://en.wikipedia.org/wiki/coffee");
$u5 = URI->new_abs("http://random.org/wiki/panama_canal", $u4->host);
$u5->host($u4->host);
$u6 = URI->new_abs("http://random.org/wiki/iron_man", $u4->host);
print "\n";
print "u4 $u4\n";
print "u5 $u5\n";
print "u6 $u6\n";
