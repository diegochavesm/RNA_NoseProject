#!/usr/bin/perl
$blast_file = $ARGV[0];
open(BLAST, "<", $blast_file);
my @list_array;
%identifiers;
%names;

my $totalreads;




	while(<BLAST>){
		next if $_ =~ m/^#/;
		chomp $_;
		$line = $_;
		@parse_line = split('\t', $line);
		

		#@id = split('\|', $parse_line[0]);
		#$names{$id[1]}="$parse_line[9]"; #this line is to assign the hash with the specie and the name of the proteini	

		$sub = $parse_line[0];
		$query = $parse_line[1];
		$lensub = $parse_line[2];
		@totalreadsmaped = split('-', $query); 
		$totalreads += $totalreadsmaped[1];
		@$sub;
				
		$names{$sub}="$parse_line[9]";
		
		unshift (@$sub, $lensub) if @$sub == 0;
		push (@$sub, $query);
		splice (@$sub,0,1,$lensub);		
			$identifiers{$sub}="@$sub";
	}


	#foreach $ele(keys %names){
	#print "$ele=>$names{$ele}\n";
	#}

%orga;
@arrayorga;

open(OUT,">", "organims.txt");
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
	print "$k\t$numreadsmaped\t$names{$k}\n";

	@orgname = split('\[', $names{$k}); 
	$oname = $orgname[1];
	substr($oname, -1) = '';
	
	if ($oname ~~ @arrayorga){
	$pastnum = $orga{$oname};
	$pastnum += $numreadsmaped;
	$orga{$oname}="$pastnum";
	next;
	}else{
	push(@arrayorga, $oname);
	$orga{$oname}=$numreadsmaped;
	}

	#print OUT "@arrayorga\n";
	
}


	foreach my $k (keys %orga){
	print OUT "$k\t$orga{$k}\n";
	}



