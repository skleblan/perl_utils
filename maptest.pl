#!/usr/bin/perl

@arr1 = (10, 1, 1, 1);
@arr2 = map { { num=>$_, str=>"hello" } } @arr1;
print "test 1: ".$arr2[0]->{num}."\n";

@arr1 = (1, 20, 1, 1);
@arr2 = map {; { num=>$_, str=>"hello" } } @arr1;
print "test 2: ".$arr2[1]->{num}."\n";
