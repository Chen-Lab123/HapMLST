#!/usr/bin/perl
$mlst_profile=shift;
%pos_gene=();
%SeqType=();
%geneExist=();
open(F1,$mlst_profile);
while($line=<F1>){
        chomp($line);
        if($line=~/^ST/){
                @genes=split("\t",$line);
                print "ST";
                for $i (1 .. $#genes){
                        $gene_matrix=$genes[$i].".mat";
                        open (FG,$gene_matrix);
                        while($gene_line=<FG>){
                                chomp($gene_line);
                                if($gene_line=~/^pos/){
                                        @geneTitles=split("\t",$gene_line);
                                        for $geneTitles (@geneTitles){
                                                $geneExist{$geneTitles}=$genes[$i];
                                        }
                                }else{
                                        @geneSNPs=split("\t",$gene_line);
                                        push @{$pos_gene{$genes[$i]}},$geneSNPs[0];
                                        for $j(1 .. $#geneTitles){
                                                $SeqType{$geneSNPs[0]}{$geneTitles[$j]}=$geneSNPs[$j];
                                        }
                                }
                        }
                        print "\t";
                        print join ("\t",@{$pos_gene{$genes[$i]}});
                        close FG;
                }
                print "\n";
        }else{
                @ST=split("\t",$line);
        #       print "ST_".$ST[0];
                $genotype="";
                for $i (1 .. $#genes){
                        $gene_type=$genes[$i]."_".$ST[$i];
                        if (exists $geneExist{$gene_type} ){
                                for $pos (@{$pos_gene{$genes[$i]}}){
					if ($SeqType{$pos}{$gene_type} ne ""){
                                        	$SeqType{$pos}{$gene_type}=$SeqType{$pos}{$gene_type};
                                	}else{
						$SeqType{$pos}{$gene_type}=0;				
					}
					$genotype.= "\t".$SeqType{$pos}{$gene_type};
				}
                        }
                }
                print "ST_".$ST[0].$genotype."\n";
        }
}
close F1;
