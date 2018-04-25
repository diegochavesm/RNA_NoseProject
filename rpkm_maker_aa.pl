#!/usr/bin/perl
$blast_file = $ARGV[0];
open(BLAST, "<", $blast_file);
my @list_array;
%identifiers;
my $totalreads;
	while(<BLAST>){
		next if $_ =~ m/^#/;
		chomp $_;
		$line = $_;
		@parse_line = split('\t', $line);
		$sub = $parse_line[0];
		$query = $parse_line[1];
		$lensub = $parse_line[2];
		@totalreadsmaped = split('-', $query); 
		$totalreads += $totalreadsmaped[1];
		@$sub;
		unshift (@$sub, $lensub) if @$sub == 0;
		push (@$sub, $query);
		splice (@$sub,0,1,$lensub);		
			$identifiers{$sub}="@$sub";
	}
print "#Num.reads maped to genome :$totalreads\n";
foreach $k (keys %identifiers) {
    	#print "$k => $identifiers{$k}\n";
	$valueslist = $identifiers{$k};
	@array_values = split (' ', $valueslist);
	$genelength = shift(@array_values);
	$numreadsmaped = 0;
		foreach (@array_values){
			@idname = split ('-', $_);
			$numreadsmaped += $idname[1];
		}
	
	$aa = $genelength*3;	
	$rpkm = ($numreadsmaped*1000000000)/($aa*$totalreads);
	$rpkmround  = sprintf("%.2f", $rpkm); #to round the number at 2 digigs afer decimal point
	#print "$k\t$rpkmround\n";
	print "$k\t$numreadsmaped\n";
}

