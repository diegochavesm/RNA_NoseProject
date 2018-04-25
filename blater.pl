#!/usr/bin/perl
use Bio::SeqIO;
use POSIX;
$file = $ARGV[0];
$numprocess = $ARGV[1];
$numseq = `grep ">" -c $file`;
chomp $numseq;
$div = ceil($numseq/$numprocess);
print "$numseq\t$div\n";
my $seqIO = Bio::SeqIO->new(-file=>$file, -format=>"Fasta");
my $limit = $div;
my $j = 0;
my $seqO;
	for(my $i=$limit+1; my $seq=$seqIO->next_seq(); $i++){
        	if($i>=$limit){ $i=0;$seqO = Bio::SeqIO->new(-file=>">file.chomp".(++$j).".fasta", -format=>"Fasta")}
        	$seqO->write_seq($seq);
	}
	
	for ($a=1; $a<= $numprocess ; $a++){
	system("nohup ~/software/blat /home/db_ncbi/human/24chromDB.fasta.2bit file.chomp$a.fasta file.chomp$a.fasta.psl 2>&1 &");	
	}


