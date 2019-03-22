#!/usr/bin/env perl
use strict;
use warnings;
use Cwd;
use File::Basename;

use constant DEBUG=>1;

my $datadir=Cwd::abs_path(dirname($0)."/../var/country");
my @args=();
for(0 .. 2) { $args[$_] = $ARGV[$_] || "" }

if ($args[0] eq "" || $args[1] eq "" || $args[2] eq "") {
	print "USAGE: $0 COUNTRY IFNAME CHAIN\n";
	exit(1);
}

# 国
my @countries=($args[0]);

# インターフェイス
my $ifname=$args[1];

# チェイン
my $chain=$args[2];

# iptables-restore
my $iptables_restore="iptables-restore --verbose --noflush";

my @buf;
push @buf,'*filter';
foreach(@countries) {
	my $filename=sprintf('%s/%s',$datadir,$_);
	open(my $fh,'<',$filename) || die "$filename - $!";
	foreach(<$fh>) {
		chomp;
		push @buf,"-A INPUT -i $ifname -s $_ -j $chain";
	}
	push @buf,'COMMIT';
}
{
	my $cmd="| $iptables_restore --verbose --noflush";
	$cmd="| cat " if DEBUG;
	open(my $fh,$cmd) || die $!;
	foreach(@buf) { print $fh "$_\n" }
}
