#!/usr/bin/perl
use strict; use warnings;

use PDF::Report;

my $pdf = new PDF::Report(PageSize => "letter",
  PageOrientation => "Portrait");

$pdf->newpage(1);

my ($pagewidth, $pageheight);
($pagewidth, $pageheight) = $pdf->getPageDimensions;

my $text = "The lithosphere, which is the rigid outermost shell of a planet (the crust and upper mantle), is broken into tectonic plates. The Earth's lithosphere is composed of seven or eight major plates (depending on how they are defined) and many minor plates.";

$pdf->addText($text, 0, ($pagewidth*0.8), 500);
$pdf->addText("Second paragraph of added text (but not actual paragraph)",
  0, ($pagewidth*0.5), 100);

$pdf->addRawText("This is raw text (x=20, y=200)", 20, 200, "black", 0, 0, 0);

$pdf->drawLine(50, 100, 100, 100);
$pdf->drawLine(50, 105, 150, 105);


$pdf->newpage(1);

$pdf->addText("Second page. Line 1. hPos = 0, width=full, height=full. included a literal newline character at the end\n", 0, $pagewidth, $pageheigh);
$pdf->addText("Second page. Line 2. same as above\n", 0, $pagewidth,
  $pageheight);
$pdf->addText("Third page. Line 3. same as above\n", 0, $pagewidth, $pageheight);

$pdf->saveAs("test.pdf");
