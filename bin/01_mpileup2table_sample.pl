#!/usr/bin/perl
$region=shift;
$file_in=$region.".mpileup";

$file_matrix=$region.".mat";
$file_pos=$region.".pos";

open (F1,$file_in);
open (F2,">$file_pos");
#open (F3,">$file_matrix");

print F2 "#chr\tpos\tAlt_No\tAll\tRef\tCount_ref\tAlt\tCount_Alt\tperc_alt\tgene\n";

while(<F1>){
	chomp;
	@items=split("\t",$_);
	@seq=split("",$items[4]);
	$count_ref=0;
	%count_alt=();
	$i=0;
	@seq_alt=();
	%alt_allele=();
	$allele_no=0;
	$j=0;
	while($i <= $#seq){
		
		if($seq[$i] eq "+"){
		#	$indel=$seq[$i];
			if($seq[$i+2] =~ /[0-9]/){
				$length_indel=$seq[($i+1)]*10+$seq[($i+2)];
				$alt_indel=join("",@seq[$i .. ($i+2+$length_indel)]);
				$i=$i+3+$length_indel;
			}else{
				$length_indel=$seq[($i+1)];
				$alt_indel=join("",@seq[$i .. ($i+1+$length_indel)]);				
				$i=$i+2+$length_indel;				
			}
			
				$alt=uc($alt_indel);
				if(exists $count_alt{$alt}){
						$count_alt{$alt}++;
						
				}else{					
						$count_alt{$alt}=1;
						$allele_no++;
						$alt_allele{$alt}=$allele_no;
				}
				$seq_alt[($j-1)]=$alt_allele{$alt};
				
		}elsif($seq[$i] eq "-" ){
		#	print $items[0]."_".$items[1],"\t$i\t$seq[$i]\t$seq[($i+1)]";
			if($seq[$i+2] =~ /[0-9]/){
				$length_indel=$seq[($i+1)]*10+$seq[($i+2)];
			#	$alt_indel=join("",@seq[$i .. ($i+2+$length_indel)]);
				$i=$i+3+$length_indel;
			}else{
				$length_indel=$seq[($i+1)];
			#	$alt_indel=join("",@seq[$i .. ($i+1+$length_indel)]);
				$i=$i+2+$length_indel;
			}
			#print "\t$i\t$seq[$i]\t$length_indel\n";
			#$count_ref++;
			#$seq_alt.=0;
			
		}elsif($seq[$i]=~ /[atcgATCG*]/){
			$alt=uc($seq[$i]);
			$i++;
			if(exists $count_alt{$alt}){
					$count_alt{$alt}++;
				#	push (@seq_alt,$alt_allele{$alt});
			}else{
					$count_alt{$alt}=1;
					$allele_no++;
					$alt_allele{$alt}=$allele_no;
				#	push (@seq_alt,$alt_allele{$alt});
			}
			$seq_alt[$j]=$alt_allele{$alt};
			$j++;
		}else{
			$i++;
		}		
	}
#	if ($alt_no==0){
	#	print F2 "$items[0]\t$items[1]\t0\t$items[3]\t$items[2]\t$count_ref\tNA\t0\t0\n";
	#	print F3 $items[0]."_".$items[1]."_0\t";
	#	print F3 join("\t",@seq_alt);
	#	print F3 "\n";
#	}else{
#	if ($allele_no>1){
	foreach $alt (sort {$count_alt{$b} <=> $count_alt{$a}} keys %count_alt){
	#foreach $alt (keys %count_alt){		
		print F2 "$items[0]\t$items[1]\t$alt_allele{$alt}\t$items[3]\t$items[2]\t$count_ref\t$alt\t$count_alt{$alt}\t".($count_alt{$alt}/$items[3])."\t$region\n";
#		print F3 $items[0]."_".$items[1]."_".$alt_allele{$alt};
	#	print $items[0]."_".$items[1]."_".$alt_allele{$alt}."\t";
	#	print join ("",@seq_alt);
	#	print "\n";
#		for $seq_alt(@seq_alt){
#			if($seq_alt eq $alt_allele{$alt}){
#				print F3 "\t1";
#			}else{
#				print F3 "\t0";
#			}
#		}
#			print F3 "\n";
	}
#	}
	
}

