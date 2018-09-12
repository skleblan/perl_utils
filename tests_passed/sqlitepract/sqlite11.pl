#!/usr/bin/perl
use warnings;
use strict;
use DBD::SQLite;

my $dbh = DBI::connect("DBI:SQLite:dbname=test2.db", "", "", { RaiseErrors => 1, AutoCommit => 1}) or die $DBI::errstr;

$dbh->do("create table if not exists ___ ") or die $dbh->errstr;

