gene=$1
ref=$2

perl ../../bin/fasta2fq.pl ${gene}.tfa > ${gene}.fq
bwa mem ${ref} ${gene}.fq |samtools view -Sb - >${gene}.bam
samtools sort ${gene}.bam -o ${gene}.sorted.bam
samtools index ${gene}.sorted.bam
samtools mpileup ${gene}.sorted.bam   >${gene}.mpileup
perl ../../bin/mpileup2table.pl ${gene}
#grep '>' ../${gene}.fas |sed 's/>//'|tr "\n" "\t"|awk '{print "pos\t"$0}'| sed 's/\t$//' >${gene}.header
samtools view ${gene}.sorted.bam |cut -f 1|tr "\n" "\t"|awk '{print "pos\t"$0}'| sed 's/\t$//' >${gene}.header
cat ${gene}.header ${gene}.mat > tmp
mv tmp ${gene}.mat
rm ${gene}.header

