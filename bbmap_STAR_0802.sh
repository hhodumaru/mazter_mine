
# bbmerge

## Length cut (15)
bbmap/bbmerge.sh in1=trimmed_U20XXX_1.fastq.gz in2=complete_adapter.T.trimmed_U2OXXX_2.fastq.gz \
 out=bbmerged.trimmed_U2OXXX.fastq outu1=R1_bbunmerged.trimmed_U2OXXX.fastq outu2=R2_bbunmerged.trimmed_U2OXXX.fastq

cat bbmerged.trimmed_U2OXXX.fastq R1_bbunmerged.trimmed_U2OXXX.fastq | gzip > merged_with_R1.trimmed_U2OXXX.fastq.gz


## No Length cut
bbmap/bbmerge.sh in1=trimmed_wo_U2OXXX_1.fastq.gz in2=complete_adapter.T.trimmed_wo_U2OXXX_2.fastq.gz \
 out=bbmerged.trimmed_wo_U2OXXX.fastq outu1=R1_bbunmerged.trimmed_wo_U2OXXX.fastq outu2=R2_bbunmerged.trimmed_wo_U2OXXX.fastq

cat bbmerged.trimmed_wo_U2OXXX.fastq R1_bbunmerged.trimmed_wo_U2OXXX.fastq | gzip > merged_with_R1.trimmed_wo_U2OXXX.fastq.gz


# parallel bbmerge code

for sample in `ls | grep U | awk -F '_' '{print $2}' | sort | uniq`
do
mkdir ${sample}
echo $sample
(../bbmap/bbmerge.sh \
    in1=trimmed_${sample}_1.fastq.gz \
    in2=complete.adapter.T.trimmed_${sample}_2.fastq.gz \
    out=bbmerged_${sample}.fastq \
    outu1=R1_bbunmerged_${sample}.fastq \
    outu2=R2_bbunmerged_${sample}.fastq && \
cat bbmerged_${sample}.fastq R1_bbunmerged_${sample}.fastq | gzip > merged_with_R1_${sample}.fastq.gz &) # 명령2
done

for sample in `ls | grep U | awk -F '_' '{print $1}' | sort | uniq`
do
mkdir ${sample}
echo $sample
(../bbmap/bbmerge.sh \
    in1=${sample}_1.fastq.gz \
    in2=${sample}_2.fastq.gz \
    out=bbmerged_${sample}.fastq.gz \
    outu1=R1_bbunmerged_${sample}.fastq.gz \
    outu2=R2_bbunmerged_${sample}.fastq.gz &) # 명령2
done




# STAR alignment 
# (written for only length cut data. Copy & modify when execute this code for no length cut data)

## Trial 1. Single End mapping with bbmerged overlap data
STAR --readFilesIn bbmerged.trimmed_U2OXXX.fastq --outSAMattrRGline ID:U2OXXX SM:U2OXXX PL:ILLUMINA \
 --genomeDir /Volumes/LaCie/MAZTER_SEQ/Resources/star_index_2.7.3a --genomeLoad NoSharedMemory \
 --outFilterMismatchNoverLmax 0.05 --outFilterMatchNmin 16 --outFilterScoreMinOverLread 0.66 \
 --outFilterMatchNminOverLread 0.66 --alignIntronMax 300 --alignMatesGapMax 1000 --outFileNamePrefix U2OXXX/bbmerged.trimmed_U2OXXX \
 --outSAMtype BAM Unsorted --outSAMunmapped Within --quantMode TranscriptomeSAM GeneCounts --runThreadN 4 --twopassMode Basic

## Trial 2. Single End mapping with bbmerged with R1 data
STAR --readFilesIn merged_with_R1.trimmed_U2OXXX.fastq.gz --outSAMattrRGline ID:U2OXXX SM:U2OXXX PL:ILLUMINA \
 --genomeDir /Volumes/LaCie/MAZTER_SEQ/Resources/star_index_2.7.3a --genomeLoad NoSharedMemory \
 --outFilterMismatchNoverLmax 0.05 --outFilterMatchNmin 16 --outFilterScoreMinOverLread 0.66 \
 --outFilterMatchNminOverLread 0.66 --alignIntronMax 300 --alignMatesGapMax 1000 --outFileNamePrefix U2OXXX/merged_with_R1.trimmed_U2OXXX \
 --readFilesCommand gzcat --outSAMtype BAM Unsorted --outSAMunmapped Within --quantMode TranscriptomeSAM GeneCounts --runThreadN 4 --twopassMode Basic

 ## Trial 3. Paired End mapping with bbunmerged data (original version)
STAR --readFilesIn R1_bbunmerged.trimmed_U2OXXX.fastq R2_bbunmerged.trimmed_U2OXXX.fastq --outSAMattrRGline ID:U2OXXX SM:U2OXXX PL:ILLUMINA \
 --genomeDir /Volumes/LaCie/MAZTER_SEQ/Resources/star_index_2.7.3a --genomeLoad NoSharedMemory \
 --alignIntronMax 300 --alignMatesGapMax 1000 --outFileNamePrefix U2OXXX/bbunmerged.trimmed.paired_U2OXXX \
 --outSAMtype BAM Unsorted --outSAMunmapped Within --quantMode TranscriptomeSAM GeneCounts --runThreadN 4 --twopassMode Basic


# parallel STAR code

for sample in `ls | grep 'trimmed' | awk -F '_' '{print $2}' | sort | uniq`
do
echo $sample
(STAR-2.7.3a/source/STAR --readFilesIn bbmerged_${sample}.fastq --outSAMattrRGline ID:${sample} SM:${sample} PL:ILLUMINA \
 --genomeDir /data2/Resources/star_index_2.7.3a --genomeLoad NoSharedMemory \
 --outFilterMismatchNoverLmax 0.05 --outFilterMatchNmin 16 --outFilterScoreMinOverLread 0.66 \
 --outFilterMatchNminOverLread 0.66 --alignIntronMax 300 --alignMatesGapMax 1000 --outFileNamePrefix ${sample}/bbmerged_${sample} \
 --outSAMtype BAM Unsorted --outSAMunmapped Within --quantMode TranscriptomeSAM GeneCounts --runThreadN 4 --twopassMode Basic && \
 STAR-2.7.3a/source/STAR --readFilesIn merged_with_R1_${sample}.fastq.gz --outSAMattrRGline ID:${sample} SM:${sample} PL:ILLUMINA \
 --genomeDir /data2/Resources/star_index_2.7.3a --genomeLoad NoSharedMemory \
 --outFilterMismatchNoverLmax 0.05 --outFilterMatchNmin 16 --outFilterScoreMinOverLread 0.66 \
 --outFilterMatchNminOverLread 0.66 --alignIntronMax 300 --alignMatesGapMax 1000 --outFileNamePrefix ${sample}/merged_with_R1_${sample} \
 --readFilesCommand gzcat --outSAMtype BAM Unsorted --outSAMunmapped Within --quantMode TranscriptomeSAM GeneCounts --runThreadN 4 --twopassMode Basic && \
 STAR-2.7.3a/source/STAR --readFilesIn R1_bbunmerged_${sample}.fastq R2_bbunmerged_${sample}.fastq --outSAMattrRGline ID:${sample} SM:${sample} PL:ILLUMINA \
 --genomeDir /data2/Resources/star_index_2.7.3a --genomeLoad NoSharedMemory \
 --alignIntronMax 300 --alignMatesGapMax 1000 --outFileNamePrefix ${sample}/bbunmerged.paired_${sample} \
 --outSAMtype BAM Unsorted --outSAMunmapped Within --quantMode TranscriptomeSAM GeneCounts --runThreadN 4 --twopassMode Basic &)
 done 
