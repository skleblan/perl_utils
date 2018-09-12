#!/usr/bin/perl
use strict;
use warnings;
use DBD::SQLite;
use File::Spec;

my $dbh = DBI->connect("dbi:SQLite:dbname=images.db", "", "", { RaiseError => 1, AutoCommit => 1}) or die $DBI::errstr;

my $sth = $dbh->prepare("select uid, name from imgdata") or die $dbh->errstr;
$sth->execute() or die $sth->errstr;
my @selectrow;
while(@selectrow = $sth->fetchrow_array)
{
  if(@selectrow > 1)
  {
    print $selectrow[0]." : ".$selectrow[1]."\n";
  }
}
print "Enter the uid that you want to retrieve:";
my $choice = <STDIN>;

$sth = $dbh->prepare("select name, data from imgdata where uid=?") or die $dbh->errstr;

$sth->execute($choice);
my ($file, $image);
$sth->bind_columns(\$file, \$image);
$sth->fetchrow_arrayref;

open IMAGEFILE, ">$file";
print IMAGEFILE $image;
close IMAGEFILE;

$sth->finish;
$dbh->disconnect;
