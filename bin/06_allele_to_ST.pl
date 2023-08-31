#!/usr/bin/perl
$alle_count=shift;
$mat=shift;
$anno_ST=shift;
$against_ST=shift;

$line=0;
%hap=();
open (F1,"$mat");
while(<F1>){
	chomp;
	if($line == 0){
		$line++;
		@STs=split;
		
	}else{
		@items=split;
		for $i(1 .. $#items){
			$hap{$items[0]}{$STs[$i]}=$items[$i];
		}
	}
}
close F1;


%support_site=();
%count_site=();
%support_ST=();
%dep_geno=();

open (F2,"$alle_count");
while ($line=<F2>){
	chomp($line);
	@items=split("\t",$line);
	@pos=split(",",$items[0]);
	
	%haplotype=();
	for $ST (@STs[1 .. $#STs] ){
		for $pos(@pos){
			$haplotype{$ST}.=$hap{$pos}{$ST};
		}
		if ($haplotype{$ST} eq $items[2]){
			push @{$support_ST{$items[0]."\t".$items[2]}},$ST;
			$support_site{$items[0]}{$ST}=$items[3];
		#	print "$ST\t$items[2]\t$haplotype{$ST}\n";
		}
	}
	$count_site{$items[0]}=$items[1];
	$dep_geno{$items[0]."\t".$items[2]}=$items[3];
	#print FO1 "$line\t";
	#print FO1 join(",",@support);
	#print FO1 "\n";
}
close F2;

%against_site=();
open (FO2,">$against_ST");
for $site( keys %count_site){
	
	@against=();
	for $ST (@STs[1 .. $#STs]){
		if (not  exists $support_site{$site}{$ST}){
			push @against,$ST;
			if($count_site{$site} >10){
				$against_site{$ST}++;
			}
		}
		
	}
	if($#against >1){
			print FO2 "$site\t$count_site{$site}\t";
			print FO2 join (",",@against);
			print FO2 "\n";
	}
}
close FO2;

open (FO1,">$anno_ST");
for $hap_site(keys %dep_geno){
	@support=();
	for $ST (@{$support_ST{$hap_site}}){
		if (not exists $against_site{$ST} ){
			push @support,$ST; 
		}
	}
	if(@support){
	print FO1 "$hap_site\t$dep_geno{$hap_site}\t".($#support+1)."\t";
	print FO1 join (",",@support);
	print FO1 "\n";
	}
}
close FO1;