#!/usr/pkg/bin/perl

# usage:
# archive_older_mail.pl arg1 arg2 arg3 etc...

use warnings;
use strict;

my @msg_file_names;
my $ls_output;
my @lines;
my $line;
my $cur_msg_file_name;
my %frmtd_dates;

##################################
# get list of all emails
##################################
@msg_file_names;
$ls_output = `ls ~skleblan/messages/`;
@lines = split $ls_output; #not providing a delimeter breaks on whitespace
for $line ( @lines )
{
  chomp $line;
  #test if not null or empty
  if( defined $line && $line neq "" )
  {
    #also check if not a directory ( -f is for file, -d is for directory )
    if( -f $line == 1 )
    {
      push @msg_file_names, $line;
      print "added $line to the list of files\n";
    }
  }
  else
  {
    print "$line is not a file\n";
  }
}

if( $#msg_file_names  < 0 )
{
  print "error: did not find any files\n";
  exit(-1);
}

##################################
# get dates of all emails
##################################
#$cur_msg_file_name

for $cur_msg_file_name ( @msg_file_names )
{
  open CUR_MSG, $cur_msg_file_name;
  @lines = <CUR_MSG>;
  close CUR_MSG;

  for $line ( @lines )
  {
#  if( $line =~ /^Date:\s/ )
    if( $line =~ /From\s\S+\@\S\s\w{3}\s---/ )
    {
      $frmtd_dates{$cur_msg_file_name} = $line;
      break;
    }
  }
}

######################################
# call a subroutine fo format the dates
######################################
for $key ( keys %frmtd_dates )
{
  $plain_date{$key} = date_to_plain_num( $frmtd_dates{$key} );
}

##################################
# create folders foreach month of each year
# in a directory called archive
##################################

##################################
# but only create a directory if there's a message
# to put in it
##################################

sub date_to_plain_num
{
my $formated_date;

$formated_date = 
}
