#!/usr/bin/perl
use strict;
use warnings;

my @plain = ("yogurt", "jane", "boeing");
my $spicy = ["salsa", "peppers", "wings"];

print @plain;
print $spicy;

my $name = \$plain[1];
my $buffalo = ${$spicy}[2];

print ref $name;
print ref $buffalo;

my $complex = {};

$complex->{bill} = "wild";
$complex->{months} = ["jan", "feb"];
push @{$complex->{months}}, "mar", "apr";
