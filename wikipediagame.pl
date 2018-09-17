#!/usr/bin/perl
use LWP::UserAgent;
use HTML::TreeBuilder;

die "program not finished\n";

# https://en.m.wikipedia.org/wiki/McKinley_Tariff
# https://en.m.wikipedia.org/wiki/Nobel_Prize_in_Physics
# https://en.m.wikipedia.org/wiki/Europe
# https://en.m.wikipedia.org/wiki/Raid_(military)
# https://en.m.wikipedia.org/wiki/Draft_(hull)
# https://en.m.wikipedia.org/wiki/Panama_Canal
# https://en.wikipedia.org/wiki/Panama_Canal
# https://en.m.wikipedia.org/wiki/Coffee
# https://en.m.wikipedia.org/wiki/Iron_Man
#

my $start_url = "";
my $end_url = "";
my $current_url = $start_url;
my $max_jumps = 20;
my $jump_count = 0;
my @jumps;

my $ua = LWP::UserAgent->new;

while($current_url ne $end_url and $jump_count < $max_jumps)
{
  my $response = $ua->get($current_url);
  push @jumps = $current_url;
  $jump_count++;
  if($response->is_success)
  {
    my $tree = HTML::TreeBuilder->new;
    $tree->parse($response->content);
    $tree->eof;

    my $prospective_link;

    foreach $link ($tree->extract_links)
    {
      #
    }
  }
}
