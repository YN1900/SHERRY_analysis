#!/bin/perl
use strict;
use warnings;

open(Bias,"<$ARGV[0]") or die "Bias file can't open";
sub norm{
	my $k=0;
	foreach(@_){
		$k = $_ if $_ > $k;
	}
	my @norm;
	foreach(@_){
		my $tmp=$_/$k;
		push @norm,$tmp;
	}	
	return @norm;
}

while(<Bias>){
	chomp($_);
	my @line=split(/\t/,$_);
	my $name=$line[0];
	my @seq=@line[1..100];
	@seq=norm(@seq);
	my $sum=0;
	foreach(@seq){
		$sum+=$_;
	}
	my $uniformity=$sum/100;
	print "$name\t$uniformity\n";
}
