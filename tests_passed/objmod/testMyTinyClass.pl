#!/usr/bin/perl
use MyTinyClass;

$uut = MyTinyClass->new;

$uut->msg("hola el mundo");
$uut->count(56);

print $uut->tostring;
