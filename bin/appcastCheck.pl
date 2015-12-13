#!/usr/bin/env perl
# appcastCheck.pl by Amory Meltzer
# Bulk process homebrew-cask appcasts to check for outdated casks

# cd /usr/local/Library/Taps/caskroom/homebrew-cask/Casks/
# grep -i "appcast" *.rb|cut -f 1 -d ':'

use strict;
use warnings;
use diagnostics;

if (@ARGV != 1) {
  print "Usage: $0 list_of_casks\n";
  exit;
}

# cask = [appcast url, original sha]
my %hash;

# Build hash
open my $casks, '<', "$ARGV[0]" or die $!;
while (<$casks>) {
  chomp;
  getCasts($_);
}
close $casks or die $!;

foreach my $key (sort keys %hash) {
  my $new = `curl $hash{$key}[0] | shasum -a 256`;
  $new =~ s/\s+-\s$//;

  if ($new ne $hash{$key}[1]) {
    print "$key\n";
  }
}


sub getCasts
  {
    my $cask = shift;
    my $appTick = 0;
    open my $file, '<', "$cask" or die $!;
    while (<$file>) {
      chomp;

      if (m/appcast/ && $appTick == 0) {
	s/.*\'(.*)\',?/$1/;
	$hash{$cask}[0] = $_;
	$appTick = 1;
	next;
      } elsif ($appTick == 1 && m/sha256/) {
	s/.*\'(\S+)\'/$1/;
	$hash{$cask}[1] = $_;
	$appTick = 0;
	last;
      } elsif ($appTick == 1 && !m/sha256/) {
	delete $hash{$cask};
	$appTick = 0;
	last;
      }
    }
    close $file or die $!;
  }
