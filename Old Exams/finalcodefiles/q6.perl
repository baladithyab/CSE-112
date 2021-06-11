#!/usr/bin/perl
use strict;
use warnings;
# open(FILE, "file.txt") or die "Could not open file: $!";

my ($lines, $words, $chars) = (0,0,0);

while (<STDIN>) {
    $lines++;
    $chars += length($_);
    $words += scalar(split(/\s+/, $_));
}

print("lines=$lines words=$words chars=$chars\n");
# print($ARGV[0]);
# print(<STDIN>);
