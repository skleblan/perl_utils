#!/usr/bin/perl
use warnings; use strict;
use Test::More;
use HTML::TreeBuilder;
use HTML::Element;

#plan tests=>3;

new_ok("HTML::TreeBuilder");
my $tree = HTML::TreeBuilder->new;
isa_ok($tree, "HTML::TreeBuilder", "object type check");

use LWP::Simple;
my $content = get("http://sdf.org");

ok(defined $content, "pre-test content generation");

$tree->parse($content);
$tree->eof;


$tree->elementify;
isa_ok($tree, "HTML::Element", "converted to HTML::Element");


done_testing;
