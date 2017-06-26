#!/usr/bin/perl

use GnuPG qw( :algo );

my $gpg = new GnuPG();

print "Enter your passphrase for encryption:\n";
my $secret = <STDIN>;

#my $input_text = `date +%A`;
system("date +%A > today.tmp");

$gpg->encrypt( plaintext => "today.tmp", output => "today.gpg",
    passphrase=>$secret);

print "Done\n";
