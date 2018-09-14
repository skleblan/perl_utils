#!/usr/bin/perl

package MyScratchObject;
use parent qw(Exporter);
#our $VERSION = "0.01";

sub new
{
  my $class = shift;
  my $self = {};

  bless $self, $class;

  $self->_init();
  return $self;
}

sub _init
{
  my $self = shift;
  $self->{priv_int_var} = 100;
}

sub getinteger
{
  my $self = shift;
  return $self->{priv_integer_variable};
}

sub setinteger
{
  my $self = shift;
  $self->{priv_integer_variable} = shift;
}

1;
