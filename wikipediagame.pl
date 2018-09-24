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

    my @links = $tree->find_by_tag_name("a");
    my $prospective_link;

    my @combo = map { {elmnt=>$_} } @links;
    map { $_->{url} = URI->new($_->{elmnt}->attr("href")) } @combo;
    map { ($_->{url}->host ? : $_->{url}->host($base_url)) } @combo;
    @combo = grep { $_->{url}->host eq $base_url } @combo;

    @combo = grep { $_->{url}->path =~ /^\/?wiki/ } @combo;

    if(scalar(@combo) > 0)
    {
      $pospective_link = $combo[0]->{url};

      my $exact_match = pop (grep {$_->{url} eq $end_url} @combo);

      if(defined $exact_match)
      { $prospective_link = $exact_match;}

    }

    $current_url = $prospective_link;
  }#end HTTP 200
  else
  { die "error occurred talking to web server\n";}

  if($promptuser)
  {
    print "do you want to (h)op to $current_url or (a)bort?\n:";
    my $contresp = <STDIO>;
    chomp $contresp;
    if(!$contresp or $contresp !~ /^h$/)
    { die "user aborted\n"; }
  }
}

#print jump list
foreach my $hop (@jumps)
{ print $hop."\n"; }

