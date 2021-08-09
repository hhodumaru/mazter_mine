bbmap/bbmerge.sh in1=tmp/U20S2-9_1.fastq.gz in2=tmp/U20S2-9_2.fastq.gz out=merged.fastq outu1=R1_unmerged.fastq outu2=R2_unmerged.fastq
cat merged.fastq R1_unmerged.fastq | gzip > merged_with_R1.fastq.gz
STAR --readFilesIn merged_with_R1.fastq.gz --outSAMattrRGline ID:U2OS2-9 SM:U2OS2-9 PL:ILLUMINA \
 --genomeDir /Users/joonan/Downloads/star_index/ --genomeLoad NoSharedMemory \
 --outFilterMismatchNoverLmax 0.05 --outFilterMatchNmin 16 --outFilterScoreMinOverLread 0.66 \
 --outFilterMatchNminOverLread 0.66 -–alignIntronMax 300 --outFileNamePrefix U2OS2-9_single/U2OS2-9_output_single.0705 \
 --readFilesCommand gzcat --outSAMtype BAM Unsorted --outSAMunmapped Within --quantMode TranscriptomeSAM GeneCounts --runThreadN 4 --twopassMode Basic

 
bbmap/bbmerge.sh in1=Data/HN00146288-mRNA/U2OS2-9_no.m15_1.fastq.gz in2=Data/HN00146288-mRNA/U2OS2-9_no.m15_2.trim.complete.fastq.gz out=merged.trimmed.fastq outu1=R1_unmerged.trimmed.fastq outu2=R2_unmerged.trimmed.fastq

cat merged.trimmed.fastq R1_unmerged.trimmed.fastq | gzip > merged_with_R1.trimmed.fastq.gz

STAR --readFilesIn merged_with_R1.trimmed.fastq.gz --outSAMattrRGline ID:U2OS2-9_trimmed_bb SM:U2OS2-9_trimmed_bb PL:ILLUMINA \
 --genomeDir /Volumes/LaCie/MAZTER_SEQ/Resources/star_index_2.7.3a --genomeLoad NoSharedMemory \
 --outFilterMismatchNoverLmax 0.05 --outFilterMatchNmin 16 --outFilterScoreMinOverLread 0.66 \
 --outFilterMatchNminOverLread 0.66 -–alignIntronMax 300 --outFileNamePrefix U2OS2-9_trimmed_bb/U2OS2-9_output_trimmed_bb.0709 \
 --readFilesCommand gzcat --outSAMtype BAM Unsorted --outSAMunmapped Within --quantMode TranscriptomeSAM GeneCounts --runThreadN 4 --twopassMode Basic

