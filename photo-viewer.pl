#!/usr/bin/perl

use strict; use warnings;
use Tk;
#use Tk::widgets qw/JPEG PNG TIFF/;
#need to be explicitly imported??
#although this current test uses a GIF, which is fine

my $mw = MainWindow->new;
$mw->Label(-text=>"Image Viewer 01")->pack;
my $img = $mw->Photo(-file=>"/home/steven/git/utils/data/trees.gif");
my $smallimg = $mw->Photo();
$smallimg->copy($img, -subsample=>(2,2));
#if trying to shrink image, cannot use same source and destination
$mw->Label(-image=>$smallimg)->pack;

MainLoop;
