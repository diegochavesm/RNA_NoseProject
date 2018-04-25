#!/usr/bin/perl
$rpkmfile = $ARGV[0];
open (RPKM, "<$rpkmfile");
	while (<RPKM>){
	chomp $_;
	next if $_ =~ m/^#/;
	@result = split ("\t", $_);
	#@idtolook = split('\_', $result[0]);
	print "$result[0]\t$result[1]\t";
	print `grep -w "$result[0]" mclOutput.groups | awk '{print \$1}'`;		
	}
