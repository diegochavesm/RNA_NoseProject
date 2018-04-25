#!/usr/bin/perl
$listfile = $ARGV[0];
open (LIST, "<$listfile");
	while(<LIST>){
	chomp $_;
	system("nohup rpstblastn -db ~/CDD/little_endian_11_2013/Cog -query ./$_ -out $_.COGS -num_threads 5  &");	
	}

