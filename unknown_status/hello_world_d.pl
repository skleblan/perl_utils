#!/usr/bin/perl

use strict;
use warnings;
use Socket;

my $port = shift || 7890; # if one isn't provided on cmd line, use 7890
my $proto = getprotobyname('tcp');
my $server = "192.168.1.100"; # Host IP running the server

# create a socket, make it reusable
socket(SOCKET, PF_INET, SOCK_STREAM, $proto)
    or die "Can't open socket $!\n";
setsockopt(SOCKET, SOL_SOCKET, SO_REUSEADDR, 1)
    or die "Can't set socket option to SO_REUSEADDR $!\n";

# bind to a port, then listen
bind(SOCKET, pack_sockaddr_in($port, inet_aton($server)))
    or die "Can't bind to port $port!\n";

listen(SOCKET, 5) or die "listen: $!";
print "SERVER started on port $port\n";

# accepting a connection
my $client_addr;
while ($client_addr = accept(NEW_SOCKET, SOCKET))
{
    # send them a message, close connection
    my $name = "unknown";
    $name = gethostbyaddr($client_addr, AF_INET);
    print NEW_SOCKET "Hello World\n";
    print "Connection received from $name\n";
    close NEW_SOCKET;
}
