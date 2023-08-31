#!/bin/bash

sample=$1
fq1=$2
fq2=$3
ref_bac=$4

echo "${sample}  running "
echo "Mapping Start"
if [ ! -f ${sample}.${ref_bac}.sorted.bam ];then
/datapool/software/anaconda3/bin/bwa mem  /datapool/stu/yuejl/MLST_tool/hapMLST/hapMLST_database/${ref_bac}/ref.fna  ${fq1}  ${fq2}|/datapool/software/anaconda3/bin/samtools view -h -bS -F4 -q20 - >${sample}.${ref_bac}.bam
/datapool/software/anaconda3/bin/samtools sort ${sample}.${ref_bac}.bam -o ${sample}.${ref_bac}.sorted.bam
fi 
echo "Mapping Complete"

echo "mpileup Start"
if [ ! -f ${sample}.${ref_bac}.mpileup ];then
#/datapool/software/anaconda3/bin/samtools sort ${sample}.bam ${sample}.sorted
/datapool/software/anaconda3/bin/samtools mpileup ${sample}.${ref_bac}.sorted.bam -l /datapool/stu/yuejl/MLST_tool/hapMLST/hapMLST_database/${ref_bac}/ST.sites|sed s'/*//'g >${sample}.${ref_bac}.mpileup
./01_mpileup2table_sample.pl ${sample}.${ref_bac}
./02_re_order_by_ref_pos.pl /datapool/stu/yuejl/MLST_tool/hapMLST/hapMLST_database/${ref_bac}/all_ST.pos ${sample}.${ref_bac}.pos >${sample}.${ref_bac}.pos_freq
fi
echo "mpileup Complete"

echo "First filter candidate ST Start"
#if [ ! -f ${sample}.reads.allele ];then
perl ./03_filter_candidate.pl ${sample}.${ref_bac}.pos_freq /datapool/stu/yuejl/MLST_tool/hapMLST/hapMLST_database/${ref_bac}/profiles.mat  ${sample}.${ref_bac}.candi_pos ${sample}.${ref_bac}.candi_mat >${sample}.${ref_bac}.first.res
#fi
echo "First filter candidate ST Complete"

echo "find reads allele Start"
#if [ -s ${sample}.first.res ] && [ ! -f ${sample}.reads.allele ];then 
awk '{print $2"\t"$3-1"\t"$3}' ${sample}.${ref_bac}.candi_pos|sort -k 1,1 -k 2,2n |uniq  >${sample}.${ref_bac}.candi.pos.bed
/datapool/software/anaconda3/bin/samtools view ${sample}.${ref_bac}.sorted.bam -L ${sample}.${ref_bac}.candi.pos.bed  -b >${sample}.${ref_bac}.candi.bam
/datapool/software/anaconda3/envs/qiime2/bin/bamToBed -i ${sample}.${ref_bac}.candi.bam  >${sample}.${ref_bac}.candi.reads.bed
/datapool/software/anaconda3/envs/qiime2/bin/intersectBed -b ${sample}.${ref_bac}.candi.pos.bed -a ${sample}.${ref_bac}.candi.reads.bed -loj  >${sample}.${ref_bac}.candi.reads.pos
./04_reads_allele.pl ${sample}.${ref_bac}.candi.bam ${sample}.${ref_bac}.candi.reads.pos >${sample}.${ref_bac}.reads.allele
#fi
echo "find reads allele Complete"

echo "Second filter candidate ST Start"
#if [ ! -f ${sample}.anno.ST ];then
./05_allele_anno_cal.pl ${sample}.${ref_bac}.reads.allele ${sample}.${ref_bac}.candi_pos ${sample}.${ref_bac}.allele.anno ${sample}.${ref_bac}.allele_count
./06_allele_to_ST.pl ${sample}.${ref_bac}.allele_count ${sample}.${ref_bac}.candi_mat ${sample}.${ref_bac}.anno.ST ${sample}.${ref_bac}.ST_against
#fi
echo "Second filter candidate ST Complete"

#if [ -s "${sample}.anno.ST" ] ;then
if [ -f "${sample}.${ref_bac}.final.boot" ];then
rm ${sample}.${ref_bac}.final.boot
else
for i in $( seq 1 200 )
do
./07_EM_estimate_random.pl ${sample}.${ref_bac}.anno.ST ${sample}.${ref_bac}.count.mat2 ${sample}.${ref_bac}.freq.mat2 ${sample}.${ref_bac}.final.res2
awk -v r=$i '{print $0"\t"r}' ${sample}.${ref_bac}.final.res2 >>${sample}.${ref_bac}.final.boot
done

fi

./08_calculateResidualSelect.pl ${sample}.${ref_bac}.candi_mat ${sample}.${ref_bac}.candi_pos ${sample}.${ref_bac}.final.boot ${sample}.${ref_bac}.residual ${sample}.${ref_bac}.final.result
#fi

echo "${sample} complete"
#./07_EM_estimate.pl ${sample}.anno.ST ${sample}.count.mat ${sample}.freq.mat ${sample}.final.res

#if [ -f "${sample}.final.boot" ];then
#rm ${sample}.final.boot
#fi 

#for i in $(seq 1 50)
#do
#./07_EM_estimate_random.pl ${sample}.anno.ST ${sample}.count.mat2 ${sample}.freq.mat2 ${sample}.final.res2
#awk -v r=$i '{print $0"\t"r}' ${sample}.final.res2 >>${sample}.final.boot
#done
#"
