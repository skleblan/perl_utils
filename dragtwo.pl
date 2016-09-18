#!/usr/bin/perl

my $line;

open FILEOUT, ">copytest";

while( $line = <STDIN> )
{
  print FILEOUT $line;
}

close FILEOUT;
