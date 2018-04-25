#!usr/bin/perl
$file = $ARGV[0]; #hits
$fastalist = $ARGV[1]; #fasta
$db = $ARGV[2];  #Database
print $file;
	
	`cat $fastalist $file | sort -n | uniq -u > $file.nonhits.list`;
	`blastdbcmd -db $db -entry_batch $file.nonhits.list > $file.nonhits.fasta`;
	`blastx -db ~/software_installed/orthomcl-v2.0.4/Epidermidis/excluxives/Exclusive_epid_DB -query $file.nonhits.fasta -num_threads 3 -out $file.nonhits_vsExclu.out`;
	`perl ~/scripts/blast2tsv2.1.pl $file.nonhits_vsExclu.out > $file.nonhits_vsExclu.out.parse`;
	`awk '{if (\$9 >= 60 ){print \$0}}' $file.nonhits_vsExclu.out.parse | sed '1d' > $file.nonhits_vsExclu.out.parse.rat60`;
	`perl ~/nose_community/transcriptomic_data/metatranscrip/scripts/blast_count.pl $file.nonhits_vsExclu.out.parse.rat60 > $file.nonhits_vsExclu.out.parse.rat60.counts`;
print "done\t";
	
