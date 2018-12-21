#!/usr/bin/perl

use strict; use warnings;
use Tk;

my $mw = MainWindow->new;
$mw->Label(-text=>"Image Viewer 01")->pack;
my $img = $mw->Photo(-file=>"/home/steven/git/utils/data/trees.gif");
#my $newimg = $mw->Photo;
$img->copy($img, -subsample=>(2,2));
$mw->Label(-image=>$img)->pack;

MainLoop;
