#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my @plain = ("yogurt", "jane", "boeing");
my $spicy = ["salsa", "peppers", "wings"];

print "plain: ".@plain."\n";
print "spicy: ".$spicy."\n";

my $name = \$plain[1];
my $buffalo = ${$spicy}[2];

print "ref name (true. is reference): ".(ref $name)."\n";
print "ref buffalo (false. is direct scalar): ".(ref $buffalo)."\n";

my $complex = {};

$complex->{bill} = "wild";
$complex->{months} = ["jan", "feb"];
push @{$complex->{months}}, "mar", "apr";

print "Dump: ".Dumper($complex)."\n";
