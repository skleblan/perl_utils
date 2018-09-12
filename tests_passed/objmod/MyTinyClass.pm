#!/usr/bin/perl
package MyTinyClass;
use Class::Tiny qw(msg count);

sub tostring
{
  $self = shift;
  return $self->msg." ".$self->count."\n";
}

1;
