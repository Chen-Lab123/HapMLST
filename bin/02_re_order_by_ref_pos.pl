#!/usr/bin/perl
$raw_pos=shift;
$input_pos=shift;
%depth=();
%depth_allele=();

open (F1,$input_pos);
while(<F1>){
	chomp;
	unless(/chr/){
		@items=split;
		$depth{$items[0]."_".$items[1]}=$items[3];
		$allele=$items[0]."_".$items[1]."_".$items[6];
		$depth_allele{$allele}=$items[7];
	}
}
close F1;

open (F2,$raw_pos);
while(<F2>){
	chomp;
	@items=split;
	print join("\t",@items[0,1,2,6]);
	if(!exists $depth{$items[0]."_".$items[1]}){
		print "\t0\t0\n";
	}else{
		print "\t".$depth{$items[0]."_".$items[1]};
		$allele_r=$items[0]."_".$items[1]."_".$items[6];
		if(exists $depth_allele{$allele_r}){
		#	print "$allele_r\n";
			print "\t".$depth_allele{$allele_r}."\t".($depth_allele{$allele_r}/$depth{$items[0]."_".$items[1]})."\n";
		}else{
			print "\t0\t0\n";
		}
	}
}
close F2;
