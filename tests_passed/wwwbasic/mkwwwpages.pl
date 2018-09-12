#!/usr/bin/perl

@names = @ARGV;

foreach(@names)
{
  &mkpage($_);
}

sub mkpage
{
  $name = shift;
  open INDEX, ">$name.html";

  print INDEX "<html><body>\n";
  print INDEX "<h1>$name</h1>\n";
  print INDEX "$name\n";
  print INDEX "</body></html>\n";

  close INDEX;
}

