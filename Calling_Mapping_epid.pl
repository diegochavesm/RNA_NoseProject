#!usr/bin/perl
$file = $ARGV[0];
$db = $ARGV[1]; 
$cov_threshold=$ARGV[2]; #here the threshold used to call the  reads from s. aureus
print $file;

	print "making blast: $file ......\n";
	$firstblast = './'.$file.'.blastvs41GDB';
	`blastn -db  /home/diego/software_installed/orthomcl-v2.0.4/Epidermidis/Genomes_nt/41DB -query $file -task blastn -num_threads 5 -out $file.blastvs41GDB` unless (-e $firstblast); ####here blast against the database of 41 genomes epidermidis DATABASE, just nucleotides
	print "blast done, parsing.... \n";
	$parseblast = './'.$file.'.blastvs41GDB.parse';
	`perl ~/scripts/blast2tsv2.1.pl $file.blastvs41GDB > $file.blastvs41GDB.parse` unless (-e $parseblast); #parser of the previous blast
	print "done parsing...........\n";
	`awk '{if (\$9 >= $cov_threshold ){print \$2}}' $file.blastvs41GDB.parse | sed 's/lcl|//g' | sed '1d' > $file.blastvs41GDB.parse.$cov_threshold.rat.id `; #### filtering for the threshold mentioned in the argv2
	"print retreaving sequences.......\n";
	`blastdbcmd -db $db -entry_batch $file.blastvs41GDB.parse.$cov_threshold.rat.id > $file.called.fasta`; #the database of the original sequences to retrievethem out of 
	
	 print "making blastv vs OGS database\n";
	`rpstblastn -query $file.called.fasta -db /home/diego/software_installed/orthomcl-v2.0.4/Epidermidis/alns/Epidermidis_3423G -out $file.calledVs41OGSDB -num_threads 5 `; #blast vs the 41OGs DATABASE
	
	print "blast done\n";

	`perl ~/scripts/blast2tsv2.1.pl $file.calledVs41OGSDB > $file.calledVs41OGSDB.parse`;
	`awk '{if (\$9 >= 60 ){print \$0}}' $file.calledVs41OGSDB.parse | sed '1d' > $file.calledVs41OGSDB.parse.ratio60 `;
	`awk '{print \$2}' $file.calledVs41OGSDB.parse.ratio60 | sed 's/lcl|//g' > $file.calledVs41OGSDB.parse.ratio60.hits`;
	`perl ~/nose_community/transcriptomic_data/metatranscrip/scripts/rpkm_maker_aa.pl $file.calledVs41OGSDB.parse.ratio60 | sed '1d' > $file.calledVs41OGSDB.parse.ratio60.counts`;
	`perl  ~/nose_community/transcriptomic_data/metatranscrip/scripts/grouplooking_epid.pl  $file.calledVs41OGSDB.parse.ratio60.counts > $file.calledVs41OGSDB.parse.ratio60.groups`;	
	`paste -d '\\t' $file.calledVs41OGSDB.parse.ratio60.counts $file.calledVs41OGSDB.parse.ratio60.groups  > $file.calledVs41OGSDB.parse.ratio60.counts_groups`; 

print "done\n";
