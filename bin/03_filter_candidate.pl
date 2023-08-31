#!/usr/bin/perl
$sample_pos_freq=shift;
$mlst_mat_file=shift;

$candi_pos_freq=shift;
$candi_mat_file=shift;

open(F1,$sample_pos_freq);
@candi_pos=();
%freq=();
%anno_freq=();
while(<F1>){
	chomp;
	@pos_freq=split();
	$pos=$pos_freq[0]."_".$pos_freq[1]."_".$pos_freq[2];
	if($pos_freq[4] >10){
	if($pos_freq[6]<0.05 or $pos_freq[5]< 2){
		$freq{$pos}=0;
	}elsif($pos_freq[6] > 0.95 or ($pos_freq[4]-$pos_freq[5]) < 2){
		$freq{$pos}=1;
	}else{
		$freq{$pos}=$pos_freq[6];
		push @candi_pos,$pos;
		$anno_freq{$pos}=join ("\t",@pos_freq);
#		print FO1 join ("\t",@pos_freq);
#		print FO1 "\n";
		
	}
	}
	
}
close F1;


open(F2,$mlst_mat_file);

#open (FO3,"> against_site");
#print FO2 "ST\t";
#print FO2 join ("\t",@candi_pos);
#print FO2 "\n";
$line=0;
%geno=();
while(<F2>){
	chomp;
	if($line==0){
		@sites=split();
	}else{
	@items=split();
	$against=0;$support=0;
	
	for $i (1 .. $#items){
		if(exists $freq{$sites[$i]}){
		if(($items[$i]==0 and $freq{$sites[$i]}==1) or ($items[$i]==1 and $freq{$sites[$i]}==0)){
			$against++;
		#	print FO3 "$items[0]\t$sites[$i]\t$items[$i]\t$freq{$sites[$i]}\n";
		}else{
			$support++;
		}
		$geno{$sites[$i]}{$items[0]}=$items[$i];
		}
	}
#	 print "$items[0]\t$support\t$against\n";
#	if($against == 0){
		print "$items[0]\t$support\t$against\n";
		push (@candi_st,$items[0]);
		#print FO2 "$items[0]";
		#for $candi_site (@candi_pos){
		#	print FO2 "\t$geno{$candi_site}";
		#}
		#print FO2 "\n";
#	}
	
	}
	$line++;
}
close FO3;
close F2;
#close FO2;
open (FO1,">$candi_pos_freq");
open (FO2,">$candi_mat_file");

print FO2 "Sites\t";
print FO2 join("\t",@candi_st);
print FO2 "\n";
for $candi_site (@candi_pos){
	$sum_geno=0;
	for $candi_st (@candi_st){
		$sum_geno+=$geno{$candi_site}{$candi_st};
	}
	#print "$candi_site\t$sum_geno\n";
	if($sum_geno >0 and $sum_geno <= $#candi_st ){
		print FO1 $candi_site."\t".$anno_freq{$candi_site}."\n";
		print FO2 $candi_site;
		for $candi_st (@candi_st){
			print FO2 "\t$geno{$candi_site}{$candi_st}";
		}
		print FO2 "\n";
	}
}
