#!/usr/bin/perl

package JudoScorer;

sub new
{
  my $class = shift;
  my $self = {};

  bless $self, $class;

  #call initialization if desired
  return $self;
}

sub _init
{
  #
}

1;
