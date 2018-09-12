#!/usr/bin/perl

use DBD::SQLite;

my $dbh = DBI->connect("DBI:SQLite:dbname=test1.db", "", "", { RaiseError => 1, AutoCommit => 1}) or die "couldnt connect\n".$DBI::errstr."\n";

$dbh->do("create table books (uid integer primary key autoincrement, title string, author string)") or die "couldnt create table\n".$dbh->errstr."\n";

my $insertsql = "insert into books (title, author) values (?, ?)";
my $sth = $dbh->prepare($insertsql) or die "cant prepare insert\n".$dbh->errstr."\n";
$sth->execute("neverwhere", "gaiman") or die "cant execute insert\n".$sth->errstr."\n";

$dbh->disconnect;
