#!/usr/bin/perl
use warnings;
use strict;
use DBD::SQLite;

my $dbh = DBI->connect("DBI:SQLite:dbname=test1.db", "", "", { RaiseError => 1, AutoCommit => 1}) or die $DBI::errstr;

$dbh->do("create table if not exists books (uid integer primary key autoincrement, title string, author string)") or die $dbh->errstr;

my %data = ( "treasure island" => "stevenson", "the great gatsby" => "fitzgerald", "frankenstein" => "shelley" );

my $insertsql = "insert into books (title, author) values (?, ?)";
my $sth = $dbh->prepare($insertsql) or die $dbh->errstr;
foreach(keys(%data))
{
  $sth->execute($_, $data{$_}) or die $sth->errstr;
}

$dbh->disconnect;
