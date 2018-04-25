#!/usr/bin/perl
#######################################################
##### V1. started on the 15 MAR 2016 		     ##
##### mapping different species in the human nose    ##
#######################################################

$seq_file = $ARGV[0];  #file after quality filtering
$database_path_assigning = $ARGV[1]; #Another file with all the paths for the databases should be writen e.g Saureus = /path/to/the/staphylococcusaureusdatabaseforMapping
$database_path_mapping = $ARGV[2];  #File showing the database to map the reads should be a protein file

$cut_off_assigning = 80; #ratio for everything but not S. aureus and S. epidermidis 
$cut_off_mapping = 80;  #ratio 


###Building the database of the sequences to extract####
`makeblastdb -in $seq_file -out $seq_file.DB -dbtype nucl -parse_seqids`  unless (-e $seq_file.DB);
#=====### ASSIGNING PROCESS #####=====#
my %process;
my @db_names;
open (DBS, "<$database_path_assigning");
	while (<DBS>){
	chomp $_;
	#print "$_\n";
	@info = split ('=', $_);
		$db = $info[1];
		$namedb = $info[0];
		push (@db_names, $namedb);
		$process{$namedb}="$db";
		`mkdir $info[0]` if $info[0];
	}

	$size = scalar keys %process;
	print "$size genomes to map\n";

	#print "array db names: @db_names\n";
	my @pids;
	for ($assig = 1; $assig<=$size; $assig++){
		$retrev = $assig - 1;
		#print "retrevvar: $retrev\n";
		#print "$db_names[$retrev]\n";
		$nametomappdb = $db_names[$retrev];
		#print "$process{$nametomappdb}\n";
		#print $namedb."<<<<<<<<<====== nameDB";
		my $pid = fork();
		if ($pid == -1) {
       		die;
   		} elsif ($pid == 0) {
		$outputfile = "./$nametomappdb/$seq_file.blastvs$nametomappdb.out";
		print "blast vs $nametomappdb is already done\n" if -e $outputfile;
		exit if -e $outputfile;
      		system ( "blastn -db $process{$nametomappdb} -query $seq_file -task blastn -num_threads 3 -out ./$nametomappdb/$seq_file.blastvs$nametomappdb.out 2>&1"), $assig or die;
		exit;  
		}
		push @pids, $pid;		
	}
	for my $pds (@pids){
	waitpid $pds, 0;
	print "done with blasting\n";
	}




### parsing ###

	my @pids_p;
	for ($assig = 1; $assig<=$size; $assig++){
		$retrev = $assig - 1;
                $nametomappdb = $db_names[$retrev];
               # print "$process{$nametomappdb}\n";
                 my $pid = fork();
                if ($pid == -1) {
                die;
                } elsif ($pid == 0) {
                system ( "~/scripts/blast2tsv2.1.pl ./$nametomappdb/$seq_file.blastvs$nametomappdb.out | awk '{if (\$9 >= $cut_off_assigning ){print \$2}}' | sed 's/lcl|//g' | sed '1d' >  ./$nametomappdb/$seq_file.blastvs$nametomappdb.out.parse.$cut_off_assigning.id  "), $assig or die;
  		exit;      
            }
	push @pids_p, $pid;
	}
   	for my $pds_p (@pids_p){
	waitpid $pds_p, 0;
	}

 #print "done parsing\n";
####### gettin reads from fasta to mappthem again another database #####
	for ($spe = 1; $spe<=$size; $spe++){
	$retrev = $spe - 1;
        $nametomappdb = $db_names[$retrev];
	### everyspe is a genome involved according to the species of mapping ###
	`blastdbcmd -db $seq_file.DB -entry_batch ./$nametomappdb/$seq_file.blastvs$nametomappdb.out.parse.$cut_off_assigning.id > ./$nametomappdb/$seq_file.blastvs$nametomappdb.out.parse.$cut_off_assigning.id.fasta`; 
	#print "getting $nametomappdb assigned sequences\n";
	}
########################################################################

###Aquaring the information of the mapping database that must be a thid argument#######

 my %mapping_databases;

	open (DBMAP, "<$database_path_mapping");
        while (<DBMAP>){
        chomp $_;
        @info_mapp = split ('=', $_);
                $db_map = $info_mapp[1];
                $namedb_map = $info_mapp[0];
                $mapping_databases{$namedb_map}="$db_map";
        }

	#foreach (keys %mapping_databases){
	#print "$_ : $mapping_databases{$_}\n";
	#}


#### BLASTING #########################	
	for ($assig = 1; $assig<=$size; $assig++){
                $retrev = $assig - 1;
                $nametomappdb = $db_names[$retrev];
                #print "$process{$nametomappdb}\n";
                my $pid = fork();
                if ($pid == -1) {
                die;
                } elsif ($pid == 0) {
                system ( "blastn -db $mapping_databases{$nametomappdb} -query ./$nametomappdb/$seq_file.blastvs$nametomappdb.out.parse.$cut_off_assigning.id.fasta -task blastn -num_threads 3 -out ./$nametomappdb/$seq_file.MAPPEDvs$nametomappdb.out 2>&1"), $assig or die;
                exit;
                }
                push @pids, $pid;
        }
        for my $pds (@pids){
        waitpid $pds, 0;
        }

#########PARSING########################

        my @pids_p;
        for ($assig = 1; $assig<=$size; $assig++){
                $retrev = $assig - 1;
                $nametomappdb = $db_names[$retrev];
               # print "$process{$nametomappdb}\n";
                 my $pid = fork();
                if ($pid == -1) {
                die;
                } elsif ($pid == 0) {
                system ( "~/scripts/blast2tsv2.1.pl ./$nametomappdb/$seq_file.MAPPEDvs$nametomappdb.out | awk '{if (\$9 >= $cut_off_mapping ){print \$0}}' >  ./$nametomappdb/$seq_file.MAPPEDvs$nametomappdb.out.$cut_off_mapping.parse"), $assig or die;
                exit;
            }
        push @pids_p, $pid;
        }
        for my $pds_p (@pids_p){
        waitpid $pds_p, 0;
        }

       
	for ($spe = 1; $spe<=$size; $spe++){
        $retrev = $spe - 1;
	$nametomappdb = $db_names[$retrev];
	#print "$nametomappdb:\n";
        print `awk '{print \$2}' ./$nametomappdb/$seq_file.MAPPEDvs$nametomappdb.out.$cut_off_mapping.parse > ./$nametomappdb/$seq_file.MAPPEDvs$nametomappdb.out.$cut_off_mapping.parse.count.hits`;
	print `perl ~/nose_community/transcriptomic_data/metatranscrip/scripts/rpkm_maker_aa.pl ./$nametomappdb/$seq_file.MAPPEDvs$nametomappdb.out.$cut_off_mapping.parse > ./$nametomappdb/$seq_file.MAPPEDvs$nametomappdb.out.$cut_off_mapping.parse.count`;
        }
print "Done with everything \n";

