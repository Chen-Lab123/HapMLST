#!/usr/bin/perl

$reads_allele=shift;
$pos_anno=shift;
$frag_anno=shift;
$haplo_count=shift;

%allele_pos=();
%haplotype=();
open(F2,$pos_anno);
while(<F2>){
	chomp;
	@items=split;
	push @{$allele_pos{$items[1]."_".$items[2]}},$items[0];
	$allele_name{$items[0]}=$items[4];
}
close F2;

open (F1,$reads_allele);
while(<F1>){
	chomp;
	@items=split;
	$pos=$items[1]."_".$items[3];
	#push $pos_frag{$items[0]},$pos;
	if(exists $allele_pos{$pos}){
		for $allele (@{$allele_pos{$pos}}){
			if ($allele_name{$allele} eq $items[4]){
				$hap=1;
			}else{
				$hap=0;
			}
			if(not exists $haplotype{$items[0]}{$allele} ){
				$haplotype{$items[0]}{$allele}=$hap;
			}elsif($haplotype{$items[0]}{$allele} ne $hap){
				delete ($haplotype{$items[0]}{$allele});
			}
		}
	}
}
close F1;

%count_all=();
%count_hap=();
open (FO1,">$frag_anno");
for $frag(keys %haplotype){
	@alleles= sort {$a cmp $b} keys (%{$haplotype{$frag}});
	$haplotype_pos=join (",",@alleles);
	$haplotype_alle="";
	for $allele (@alleles){
		$haplotype_alle.=$haplotype{$frag}{$allele};
	}
	$count_all{$haplotype_pos}++;
	$count_hap{$haplotype_pos}{$haplotype_alle}++;
	print FO1 "$frag\t$haplotype_pos\t$haplotype_alle\n";
}
close FO1;

open (FO2,">$haplo_count");
for $haplotype_pos (keys %count_all){
	for $haplotype_alle (keys %{$count_hap{$haplotype_pos}}){
		print FO2 "$haplotype_pos\t$count_all{$haplotype_pos}\t$haplotype_alle\t$count_hap{$haplotype_pos}{$haplotype_alle}\n";
	}
}
close FO2;
