#!/usr/bin/perl
$list = $ARGV[0];
open (LIST, "<$list");
	while(<LIST>){
	chomp $_;
	system("nohup perl ~/nose_community/transcriptomic_data/metatranscrip/scripts/parse_blat.pl $_ 30 > $_.parse 2>&1 &");
	}

print "all running .....\n";

