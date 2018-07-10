#!/usr/bin/perl

package Greetings;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(english spanish);
#@EXPORT_OK = qw();
#not autoexported, but available

sub english
{
  return "Hello World.\n";
}

sub spanish
{
  return "Hola El Mundo.\n";
}

1;
