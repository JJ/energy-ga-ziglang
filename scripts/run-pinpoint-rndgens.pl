#!/usr/bin/env perl

use strict;
use warnings;

use v5.14;

use lib qw(lib ../lib ../../lib);
use Utils qw(process_pinpoint_output);

my $preffix = shift || die "I need a prefix for the data files";
my $data_dir = shift || "data";
my $ITERATIONS = 30;
my ($mon,$day,$hh,$mm,$ss) = localtime() =~ /(\w+)\s+(\d+)\s+(\d+)\:(\d+)\:(\d+)/;
my $suffix = "$day-$mon-$hh-$mm-$ss";

open my $fh, ">", "$data_dir/$preffix-$suffix.csv";
say $fh "Platform,size,GPU,PKG,seconds";

for my $l ( 0..5 ) {
  my $total_seconds;
  my $successful = 0;
  my @results;
  do {
    my $command = "zig-out/bin/rnd_tester $l";
    say $command;
    my $output = `pinpoint $command 2>&1`;
    say $output;
    my ( $gpu, $pkg, $seconds ) = process_pinpoint_output $output;
    if ($gpu != 0 ) {
      $successful++;
      $total_seconds += $seconds;
      say "$preffix, $l, $gpu ,$pkg";
      push @results, [$gpu, $pkg,$seconds];
    }
  } while ( $successful < $ITERATIONS );

  foreach  my $row (@results) {
    say join(", ", @$row);
    say $fh "$preffix, $l, ", join(", ", @$row);
  }
}
close $fh;
