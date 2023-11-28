###以ecoli为例

##01.利用mlst软件整理的MLST_database序列信息，得到7个管家基因序列文件(*.tfa);profile文件(*.txt)

##02.确定该物种的参考基因组：优先选择complete genome
cd ./db/pubmlst/ecoli
less ../../refseq_complete.list |grep 'Escherichia coli'>refer_genome_download.info
less refer_genome_download.info|awk -F"/" '{print "wget -c "$0}' >wget.sh
sh wget.sh 
less refer_genome_download.info|awk -F"/" '{print "mv "$NF" ref.fna"}'>mv.sh
sh mv.sh

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
