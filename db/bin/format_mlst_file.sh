head profiles.txt -n1|tr "\t" "\n"|sed '/ST/d'|sed '/clonal_complex/d' >gene_list
bwa index ref.fna
cat gene_list |while read gene;do 
../fq2table.sh ${gene} ref.fna ;
done 
perl ../combine_gene.pl profiles_ST.txt >profiles.mat 2>err 
head profiles.mat -n1|sed 's/\t/\n/g'|sed '1d'|sed 's/_/\t/g'|cut -f 1,2|sort -k 2,2n -u >ST.sites
cat gene_list|while read g;do
cat $g.pos|sed '/#chr/d'|sort  -k2n -u  >>all_ST.pos
done
