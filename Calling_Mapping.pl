#!usr/bin/perl
$file = $ARGV[0];
$db = $ARGV[1]; 
$cov_threshold=$ARGV[2]; #here the threshold used to call the  reads from s. aureus
print $file;
	`blastn -db  ~/s_aureus/database/fna_files/genomes/25GDB -query $file -task blastn -num_threads 5 -out $file.blastvs25GDB` unless (-e "$file.blastvs25GDB");
	print "blastdone\n";
	`perl ~/scripts/blast2tsv2.1.pl $file.blastvs25GDB > $file.blastvs25GDB.parse`;
	`awk '{if (\$9 >= $cov_threshold ){print \$2}}' $file.blastvs25GDB.parse | sed 's/lcl|//g' | sed '1d' > $file.blastvs25GDB.parse.$cov_threshold.rat.id `;
	`blastdbcmd -db $db -entry_batch $file.blastvs25GDB.parse.$cov_threshold.rat.id > $file.called.fasta`;
	`rpstblastn -query $file.called.fasta -db ~/software_installed/orthomcl-v2.0.4/25.newgenomes/pssmS/corelist.list -out $file.calledVsOGS25DB -num_threads 5 `;
	`perl ~/scripts/blast2tsv2.1.pl $file.calledVsOGS25DB > $file.calledVsOGS25DB.parse`;
	`awk '{if (\$9 >= 60 ){print \$0}}' $file.calledVsOGS25DB.parse | sed '1d' > $file.calledVsOGS25DB.parse.ratio60 `;
	`awk '{print \$2}' $file.calledVsOGS25DB.parse.ratio60 | sed 's/lcl|//g' > $file.calledVsOGS25DB.parse.ratio60.hits`;
	`perl ~/nose_community/transcriptomic_data/metatranscrip/scripts/rpkm_maker_aa.pl $file.calledVsOGS25DB.parse.ratio60 | sed '1d' > $file.calledVsOGS25DB.parse.ratio60.counts`;
	`perl  ~/scripts/transcrip/grouplooking.pl $file.calledVsOGS25DB.parse.ratio60.counts > $file.calledVsOGS25DB.parse.ratio60.groups`;	
	`paste -d '\\t' $file.calledVsOGS25DB.parse.ratio60.counts $file.calledVsOGS25DB.parse.ratio60.groups  > $file.calledVsOGS25DB.parse.ratio60.counts_groups`; 

print "done\n";
