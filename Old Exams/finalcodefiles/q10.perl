#!/usr/bin/perl

use strict;
use warnings;
$0 =~ s|.*/||;
# print("$0\n");

for my $file (@ARGV) {
    my @stats = stat($file);
    my $size = 0;
    if(@stats){
        $size = $stats[7];
        print(STDOUT "$file: $size bytes\n");
    }
    else{
        print(STDERR "$0: $file: No such file or directory\n");
    }
}