perl ../combine_gene_new.pl profiles_ST.txt >profiles.mat 
head profiles.mat -n1|sed 's/\t/\n/g'|sed '1d'|sed 's/_/\t/g'|cut -f 1,2|sort -k 2,2n -u >ST.sites
