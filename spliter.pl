use strict;
use Bio::SeqIO;

my $file = shift @ARGV;
my $limit = shift @ARGV;
my $seqIO = Bio::SeqIO->new(-file=>$file, -format=>"Fasta");
#my $limit = 134467;
my $j = 0;
my $seqO;
for(my $i=$limit+1; my $seq=$seqIO->next_seq(); $i++){
        if($i>=$limit){ $i=0;$seqO = Bio::SeqIO->new(-file=>">file.chomp".(++$j).".fasta", -format=>"Fasta")}
        $seqO->write_seq($seq);
}


