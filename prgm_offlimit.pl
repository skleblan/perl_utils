#!/usr/bin/perl

#==============================================================
# prevents access to the movie-player program "totem" or "vlc"
# if it is between 6am and 8am
#==============================================================

my $hour;
my $program_cmd = "";
my $time_cmd = "date +%H";
# %H is hours (00 to 23)
# %k is hours ( 0 to 23)
# %M is minutes (00 to 59)
# %S is seconds (00 to 59)
#SPECIAL: %s is seconds since epoch

#get the hour
$hour = `$time_cmd`;

# if the hour is 6 or 7
if($hour =~ /[67]/)
{
    print "not allowed to watch movies between 6am and 8am\n";
}
else
{
    system($program_cmd);
}

exit(0);

