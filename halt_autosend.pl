#!/usr/bin/perl
#=====================================================
# sends and INT signal to the notify_skl.pl script
#=====================================================
my $pid;
my $command;

#according to ps -ef on console2
#                user   pid    ppid   otherstuff
my $regex =     "\w+\s+(\d+)\s+\d+";

my @lines = `ps -ef | grep notify_skl.pl`;

for(my $i = 0; $i <= $#lines; $i++)
{
    if($lines =~ /$regex/)
    {
        $pid = $1;
        break;
    }

$command = "kill -INT $pid";

system($command);

exit(0);