#!/usr/bin/env perl
#===============================================================================
#
#         FILE: cache-search.pl
#
#  DESCRIPTION: 
#
#      VERSION: 1.0
#      CREATED: 05/07/2020 01:54:20 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

my $usage = "Usage: perl $0 <directory> <string 1> [<string 2> ...]";
die $usage."\n" unless @ARGV >= 2;
my $main_dir = shift;
my $folder_max_depth = 0;
my $search_str = join " ", @ARGV;
print "Searching $main_dir for \"$search_str\"...\n";

#TODO: handle multiple words as search criteria
#TODO: handle dashes
#TODO: handle quotation marks
#TODO: leverage Text::Fuzzy module
#TODO: turn into a module/web-api/web-app

my @file_list = ();

opendir SEARCHDIR, $main_dir or die "Unable to open $main_dir\n";
my $cur_entry;
while($cur_entry = readdir SEARCHDIR)
{
#  if(-e $cur_entry and -f $cur_entry)
  {
    #grab all files, but exclude directories
    #hopefully, the above logic also filters out "." and ".."
    push @file_list, $cur_entry;
  }
}

print "Searching @{[ scalar(@file_list) ]} files...\n";
my $matches_count = 0;
foreach my $f (@file_list)
{
  if($f =~ /$search_str/i)
  {
    print "$f\n";
    $matches_count++;
  }
}
print "Found $matches_count matches\n";

__END__

NOTES:

use module Text::Fuzzy

function prototypes?


