#!/usr/bin/perl
use strict;
use warnings;
use DBD::SQLite;
use File::Spec;

my $imgpath = shift;
my ($vol, $path, $file) = File::Spec->splitpath($imgpath);

my $dbh = DBI->connect("dbi:SQLite:dbname=images.db", "", "", { RaiseError => 1, AutoCommit => 1}) or die $DBI::errstr;

$dbh->do("create table if not exists imgdata (uid integer primary key autoincrement, name string, data blob)") or die $dbh->errstr;

my ($wholeimage, $buffer);

open IMAGEFILE, $imgpath or die $!;
while (read IMAGEFILE, $buffer, 1024)
{
  $wholeimage .= $buffer;
}
close IMAGEFILE;

my $sth = $dbh->prepare("insert into imgdata (name, data) values (?, ?)") or die $dbh->errstr;
$sth->execute($file, $wholeimage) or die $sth->errstr;

$dbh->disconnect;
