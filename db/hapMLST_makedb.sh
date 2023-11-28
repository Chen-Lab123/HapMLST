###以ecoli为例

##01.利用mlst软件整理的MLST_database序列信息，得到7个管家基因序列文件(*.tfa);profile文件(*.txt)

##02.确定该物种的参考基因组：优先选择complete genome
cd ./pubmlst/ecoli
less ./db/refseq_complete.list |grep 'Escherichia coli'>refer_genome_download.info
wget -c ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/005/845/GCA_000005845.2_ASM584v2/GCA_000005845.2_ASM584v2_genomic.fna.gz
gunzip GCA_000005845.2_ASM584v2_genomic.fna.gz
mv GCA_000005845.2_ASM584v2_genomic.fna ref.fna

##03.构建hapMLST_db
mv *.txt profiles_ST.txt
less profiles_ST.txt |head -n1|cut -f 2,3,4,5,6,7,8|tr '\t' '\n'>gene_list
bwa index ref.fna
cat gene_list |while read gene;do 
../../bin/fq2table.sh  ${gene} ref.fna ;
done
perl ../../bin/combine_gene_new.pl profiles_ST.txt >profiles.mat 
head profiles.mat -n1|sed 's/\t/\n/g'|sed '1d'|sed 's/_/\t/g'|cut -f 1,2|sort -k 2,2n -u >ST.sites
cat gene_list|while read g;do
cat $g.pos|sed '/#chr/d'|sort  -k2n -u  >>all_ST.pos
done
