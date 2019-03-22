#!/usr/bin/env perl
# UTF-8 あ
use utf8;
use strict;
use warnings;

my %cidr;
foreach(1..32) {
	$cidr{ 2 ** $_ }=32-$_;
}
my %country;
foreach(<>) {
	chomp;
	if(/^apnic\|([A-Z]{2})\|ipv4\|([0-9\.]+)\|(\d+)\|(\d+)\|allocated$/) {
		$country{$1}||=[];
		push @{$country{$1}},"$2/$cidr{$3}";
	}
}
while(my($ct,$ip)=each %country) {
	my $filename="var/country/$ct";
	print "Write: $filename\n";
	open(my $fh,'>:utf8',$filename) || die "$filename - $!";
	foreach(@{$ip}) { print $fh "$_\n" }
}
