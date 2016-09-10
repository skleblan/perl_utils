#!/usr/bin/perl
#================================================================
# notifies steve whenever someone logs in unless they've run
# the appropriate post-login command
# ==============================================================

my $timeout = 5 * 60; #5 minutes
my $cancelled = 0;
my $phone = "$phonenumber@vtext.com";  #TODO: put in real number
my $msg_loc = "/tmp/notify_skl.msg_out";

my $user = `whoami`;
my $machine = `hostname`;
my $datetime = `date`;

my $command = "perl /home/steven/bin/sendmail-wrapper.pl -f -t $phone -m $msg_loc";

# SETUP HOOK FOR CANCELLING HERE
#################################
$SIG{'INT'} = "INT_handler";

sleep $timeout;

open MSG, ">$msg_loc";
printf MSG "$user has logged in to $machine via <some method> at $datetime\n";
close MSG;

if(!$cancelled)
{
    system($command);
}
else
{
    print "message NOT sent to steve's phone\n";
}

exit(0)

#########################
# ADD CATCH HERE
#########################

sub INT_handler
{
    $cancelled = 1;
    exit(0);
}
