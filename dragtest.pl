#!/usr/bin/perl

my $filename;
my @lines;
my $line;

$filename = shift @ARGV;

open FILEIN, "<$filename";
@lines = <FILEIN>;
close FILEIN;

open FILEOUT, ">$filename.copy";
for $line ( @lines )
{
  print FILEOUT $line;
}
close FILEOUT;
