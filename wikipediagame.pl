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

my $base_url = "en.wikipedia.org";
my $start_url = URI->new("");
my $end_url = URI->new("");

die "all urls must be for wikipedia\n" unless $start_url->base eq $base_url;
die "all urls must be for wikipedia\n" unless $end_url->base eq $base_url;

my $current_url = $start_url;
my $max_jumps = 40;
my $jump_count = 0;
my @jumps;

my $ua = LWP::UserAgent->new;

while($current_url ne $end_url and $jump_count < $max_jumps)
{
  sleep 3; #dont spam the wikipedia web server

  my $response = $ua->get($current_url);
  push @jumps = $current_url;
  $jump_count++;
  if($response->is_success)
  {
    my $tree = HTML::TreeBuilder->new;
    $tree->parse($response->content);
    $tree->eof;

    my $prospective_link;

    foreach my $link ($tree->find_by_tag_name("a"))
    {
      my $cur_url = URI->new($link->attr("href"));

      if($cur_url and $cur_url->host ne $base_url)
      { next; }

      if(not $cur_url->host)
      { $cur_url->host($base_url); }

      if(not defined $prospective_link);
      {
        $prospective_link = $cur_url;
      }

      if($cur_url eq $end_url)
      {
        $prospective_link = $cur_url;
        last;
      }
    }#end loop thru links on cur page

    $current_url = $prospective_link;
  }#end HTTP 200
}

#print jump list
foreach my $hop (@jumps)
{ print $hop."\n"; }

