#!/usr/bin/perl
$blatout = $ARGV[0];
$cutoff = $ARGV[1];
open (BLAT, "<$blatout");
	while (<BLAT>){
	chomp $_;
	next if $_ !~ m/^[0-9]/; 
	@line = split('\t', $_);
	$querylength = $line[10];
	$qstart = $line[11];
	$qend = $line[12];
	$aln_len = $qend - $qstart;
	$aln_cov = (($aln_len * 100)/$querylength);
	print "$_\n" if $aln_cov >= $cutoff; 
		


	
#	print "$line[10]\t$aln_len\t$aln_cov\n";
	}
