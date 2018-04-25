#!/usr/bin/perl
$query = $ARGV[0];  #query file
$database = $ARGV[1]; #list of the databases with the path
open (DB, "<$database");
	while(<DB>){
	chomp $_;
	#print $_."\n";
	@namedb = split ('\/', $_);
	$name = pop (@namedb);
	print $name."\n";
	system("nohup blastn -task blastn -query $query  -db $_ -out $query.vs$name -evalue 1e-15 &");
	}

