#!/usr/bin/perl
$anno_hap=shift;
#$initial_freq=shift;
$count_matrix=shift;
$freq_matrix=shift;
$final_result=shift;

open (F1,$anno_hap);

%dep_hap=();
%count_ST=();
$count_all=0;
%ST_support=();
#%site_support=();
while(<F1>){
	chomp;
	@items=split;
	$site=$items[0]."\t".$items[1];
	$dep_hap{$site}=$items[2];
	@STs=split(",",$items[4]);
	@{$ST_support{$site}}=@STs;
	for $ST(@STs){
		#$dep_ST{$site}{$ST}=$items[2]/$items[3];
		$count_ST{$ST}+=$items[2]/$items[3];
		#push @{$site_support{$ST}},$site;
	}
	
	$count_all+=$items[2];
}
close F1;

open (FO1,">$count_matrix");
open (FO2,">$freq_matrix");

@candi_ST=keys %count_ST;
print FO1 "round\t";
print FO1 join("\t",@candi_ST);
print FO1 "\n";

print FO2 "round\t";
print FO2 join("\t",@candi_ST);
print FO2 "\n";

$em_est=1;
$round=0;
$tmp_sum=0;
print FO1 "$round";
print FO2 "$round";
for $ST (@candi_ST){
		$count_ST{$ST}=int(rand(100));
		$tmp_sum=$tmp_sum+$count_ST{$ST};
	}
for $ST (@candi_ST){
	$freq_ST{$ST}=$count_ST{$ST}/$tmp_sum;
#	$freq_ST{$ST}=$count_ST{$ST}/$count_all;
	print FO1 "\t$count_ST{$ST}";
	print FO2 "\t$freq_ST{$ST}";
}
#print "\t$count_all";
print FO1 "\n";
print FO2 "\n";

while($em_est>0){
	%count_ST=();
	for $site (keys %dep_hap){
		#%candi_site_ST=%{$dep_ST{$site}};
		$max_freq=0;
		$max_ST="";
		#print STDERR "$site\t$dep_hap{$site}\t";
		$freq_all=0;
		for $ST( @{$ST_support{$site}}){
			$freq_all+=$freq_ST{$ST};
			if($freq_ST{$ST} > $max_freq ){
				$max_freq = $freq_ST{$ST};
				$max_ST=$ST;
			}
		}
		$left=$dep_hap{$site};
		for $ST( @{$ST_support{$site}}){
			$freq_adj=$freq_ST{$ST}/$freq_all;
			$hap_count=int($dep_hap{$site}*$freq_adj);
			$count_ST{$ST}+=$hap_count;
			$left=$left-$hap_count;
			#print STDERR "$ST:$freq_adj:$hap_count:$count_ST{$ST}\t";
		}
		if($left !=0 ){
			$count_ST{$max_ST}=$count_ST{$max_ST}+$left;
			#print STDERR "left:$left:$max_ST";
		}
		#print STDERR "\n";
	}
	$round++;
	print FO1 "$round";
	print FO2 "$round";
	$em_est=0;
	#$tmp_sum=0;
	for $ST (@candi_ST){
		$freq_new=$count_ST{$ST}/$count_all;
		$residual=($freq_ST{$ST}-$freq_new)**2;
		$em_est+=$residual;
		$freq_ST{$ST}=$freq_new;
		print FO1 "\t$count_ST{$ST}";
		print FO2 "\t$freq_ST{$ST}";
		#$tmp_sum+=$count_ST{$ST};
	}
	#print "\t$tmp_sum";
	print FO1 "\n";
	print FO2 "\n";
}
close FO1;
close FO2;

open (FO3,">$final_result");
for $ST (@candi_ST){
	print FO3 "$ST\t$freq_ST{$ST}\t$count_ST{$ST}\t".($count_all-$count_ST{$ST})."\n";
}
close FO3;
