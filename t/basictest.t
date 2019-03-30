#!/usr/bin/perl

use strict; use warnings;
use Test::More;

plan tests=>6;

ok(join(" ", ("hello", "world")) eq "hello world", "string join test");
is(6, 3+3, "basic addition test");
pass("no reason");

my $svar = undef;
SKIP: {
  skip "don't understand context", 1;
  ok(not $svar, "scalar initialized to undef");
};
$svar = 5;
ok(defined $svar, "scalar defined");
is($svar, 5, "scalar set to 5");

my %testhash = ();
is(scalar keys %testhash, 0, "hash is initially empty");

exit;
