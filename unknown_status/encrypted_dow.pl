#!/usr/bin/perl

use GnuPG qw( :algo );

my $gpg = new GnuPG();

#my $input_text = `date +%A`;
system("date +%A > today.tmp");

$gpg->encrypt( plaintext => "today.tmp", output => "today.gpg",
    recipient=>"steven\@laptop2");

print "Done\n";
