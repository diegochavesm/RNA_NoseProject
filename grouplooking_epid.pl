#!/usr/bin/perl
$rpkmfile = $ARGV[0];
open (RPKM, "<$rpkmfile");
	while (<RPKM>){
	chomp $_;
	next if $_ =~ m/^#/;
	@result = split ("\t", $_);
	@idtolook = split('\|', $result[0]);
	print "$idtolook[1]\t$result[1]\t";
	print `grep -w "$idtolook[1]" /home/diego/software_installed/orthomcl-v2.0.4/Epidermidis/anot/mclOutput.groups | awk '{print \$1}'\n`;	
	}
