#!/usr/bin/perl

$candi_mat=shift;
$candi_pos=shift;
$st_result=shift;

$boot_residual=shift;
$final_select=shift;

open (F1,$candi_mat);
%geno=();
$line=0;
while(<F1>){
	chomp;
	if($line == 0){
		@STs= split;
		$line++;
	}else{
		@items=split;
		for $i(1 .. $#STs){
			$geno{$items[0]}{$STs[$i]}=$items[$i];
		}
	}
}
close F1;

open (F2,$candi_pos);
%freq_pos=();
while(<F2>){
	chomp;
	@items=split;
	$freq_pos{$items[0]}=$items[7];
}
close F2;

open(F3,$st_result);
%freq_st=();
%anno_st=();
while($line=<F3>){
	chomp ($line);
	@items=split("\t",$line);
	$freq_st{$items[4]}{$items[0]}=$items[1];
	$anno_st{$items[4]}{$items[0]}=$line;
}
close F3;
%freq_pos_exp=();
%residual=();
open (FO1,">$boot_residual");
for $reset (sort {$a <=> $b} keys %freq_st){
	$residual{$reset}=0;
	for $pos (keys %freq_pos){
		$freq_pos_exp{$pos}=0;
		for $ST(@STs[1 .. $#STs]){
			if(exists $freq_st{$reset}{$ST}){
				$freq_pos_exp{$pos} += $geno{$pos}{$ST}*$freq_st{$reset}{$ST};
			}
		#	print "$pos\t$ST\t$geno{$pos}{$ST}\t$freq_st{$reset}{$ST}\t$freq_pos_exp{$pos}\n";
		}
		$residual{$reset}+=($freq_pos{$pos}-$freq_pos_exp{$pos}) ** 2;
	}
	
	for $pos (sort {$a <=> $b} keys %freq_pos){
		print FO1 "$reset\t$pos\t$freq_pos{$pos}\t$freq_pos_exp{$pos}\t$residual{$reset}\n";
	}
}
close FO1;

open (FO2,">$final_select");
@sorted_reset= sort { $residual{$a} <=> $residual{$b} } keys %residual ;
$select_reset=$sorted_reset[0];
for $ST(@STs[1 .. $#STs] ){
	if (exists $anno_st{$select_reset}{$ST}){
		print FO2 "$anno_st{$select_reset}{$ST}\n";
	}else{
		print FO2 "$ST\t0\t0\n";
	}
	#print $anno_st{$select_reset}{$ST}."\n";
}
close FO2;
