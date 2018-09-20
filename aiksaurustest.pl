#!/usr/bin/perl

#requires installation of aiksaurus binary software in addition to the perl module

use Text::Thesaurus::Aiksaurus;
use Data::Dumper;

$word = shift;
$word = "happy" unless defined $word;

$engine = Text::Thesaurus::Aiksaurus->new;
%results = $engine->search($word);
print Dumper(%results);
