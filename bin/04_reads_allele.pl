#!/usr/bin/perl
$bam_in=shift;
$reads_pos=shift;
#$candi_pos=shift;
#$candi_mat=shift;

%allele_position=();

open (F1,$reads_pos);
while($line=<F1>){
	chomp($line);
	@items=split("\t",$line);
	$frag=(split("/",$items[3]))[0];
	$reads=$frag."_".($items[1]+1);
	push @{$allele_position{$reads}},$items[8];
}
close F1;


open (F2,"/datapool/software/anaconda3/bin/samtools view $bam_in|");
#open (F2,$bam_in);
while($line=<F2>){
	chomp($line);
	@items=split("\t",$line);
#	print STDERR "$items[0]\n";	
	$reads=$items[0]."_".$items[3];
	if(exists $allele_position{$reads}){
		$cigar=$items[5];
		$start=$items[3];
		$position=0;
		%allele_pos=();
		@seq=split("",$items[9]);
#		print "$cigar\n";
		if($cigar != "*"){
		while ($cigar !~ /^$/){
			if($cigar =~ /^([0-9]+[MIDSH])/){
				$cigar_part=$1;
				if($cigar_part =~ /([0-9]+)M/){
				#	print "$1\t$position\n";
					$end=$start+$1;
					for $pos ($start .. $end){
						$allele_pos{$pos}=$seq[$position];
					#	print "$pos\t$position\t$seq[$position]\n";
						$position++;
					}
				
					$start=$end;
				}elsif($cigar_part =~ /([0-9]+)I/){
					$end=$start+$1;
					$allele_pos{$start}=join ("",@seq[$start .. $end]); 
					$position=$position+$1;
					$start++;
				}elsif($cigar_part =~ /([0-9]+)D/){
					$end=$start+$1;
					for $pos ($start .. $end){
						$allele_pos{$pos}="*";
					}
					$start=$end;
				}
#				print  STDERR "$reads\t$cigar_part\t$start\t$end\n";
			$cigar =~ s/$cigar_part//;
			}			
		}
		for $pos (@{$allele_position{$reads}}){
			print  "$items[0]\t$items[2]\t$reads\t$pos\t$allele_pos{$pos}\n";
		}
		}
	}else{
#		print STDERR "NotExsit:$items[0]\n";
	}
}

close F2;

