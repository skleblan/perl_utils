#!/usr/bin/perl

#TODO: check for existing index.html
#TODO: check for this script in the cur dir

#get path to current working dir
$workingdir = $ENV{"PWD"};

@excluded_files = ($0, ".", "..");

opendir($dh, $workingdir);
@dirs = grep { -d "$workingdir/$_" } readdir($dh);
closedir($dh);

#get list of files. doesnt include sub-dirs
opendir($dh, $workingdir);
@files = grep { -f "$workingdir/$_" } readdir($dh);
foreach $exclusion (@excluded_files)
{
  @files = grep { not ($_ eq $exclusion) } @files;
}
closedir($dh);

open INDEX, ">index.html";

print INDEX "<html><body>\n";
print INDEX "<h1>Main Index</h1>\n";
foreach(@dirs)
{
  print INDEX "<a href=\"$_\">$_</a><br/>\n";
}

print INDEX "<br/>\n";

foreach(@files)
{
  #create a link to each file in the dir
  print INDEX "<a href=\"$_\">$_</a><br/>\n";
}
print INDEX "</body></html>\n";
close INDEX;

