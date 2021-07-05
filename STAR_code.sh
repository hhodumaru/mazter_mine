
## Original Version

for sample in `ls | grep U | awk -F'_' '{print $1}' | uniq`; do mkdir ${sample}; (STAR \
--readFilesIn ${sample}_1.fastq.gz ${sample}_2.fastq.gz \
--outSAMattrRGline ID:${sample} SM:${sample} PL:ILLUMINA \
--genomeDir /home/sonic/Dropbox/index/human/gencode_hg38_v32/star_index_2.7.3a \
--genomeLoad NoSharedMemory \
-–alignIntronMax 300 \
-–alignMatesGapMax 1000 \
--outFileNamePrefix ${sample}/${sample}_output.3bp_0614 \
--readFilesCommand zcat \
--outSAMtype BAM Unsorted \
--outSAMunmapped Within \
--quantMode TranscriptomeSAM GeneCounts \
--runThreadN 8 \
--twopassMode Basic &) ; done



## Dobin Recommended Version

for sample in `ls | grep U | awk -F'_' '{print $1}' | uniq`; do mkdir ${sample}; (STAR \
--readFilesIn ${sample}_1.fastq.gz ${sample}_2.fastq.gz \
--outSAMattrRGline ID:${sample} SM:${sample} PL:ILLUMINA \
--genomeDir /Volumes/LaCie/MAZTER_SEQ/Resources/star_index_2.7.3a \
--genomeLoad NoSharedMemory \
--outFilterMismatchNoverLmax 0.05 \
--outFilterMatchNmin 16 \
--outFilterScoreMinOverLread 0 \
--outFilterMatchNminOverLread 0 \
-–alignIntronMax 1 \
--outFileNamePrefix ${sample}/${sample}_output_dobin.ver \
--readFilesCommand gzcat \
--outSAMtype BAM Unsorted \
--outSAMunmapped Within \
--quantMode TranscriptomeSAM GeneCounts \
--runThreadN 8 \
--twopassMode Basic &) ; done

STAR --readFilesIn U2OS2-9_1.fastq.gz U2OS2-9_2.fastq.gz --outSAMattrRGline ID:U2OS2 SM:U2OS2 PL:ILLUMINA --genomeDir /Volumes/LaCie/MAZTER_SEQ/Resources/star_index_2.7.3a --genomeLoad NoSharedMemory --outFilterMismatchNoverLmax 0.05 --outFilterMatchNmin 16 --outFilterScoreMinOverLread 0 --outFilterMatchNminOverLread 0 --outFileNamePrefix U2OS2-9_relaxed/U2OS2-9_output_relaxed.0619 --readFilesCommand gzcat --outSAMtype BAM Unsorted --outSAMunmapped Within --quantMode TranscriptomeSAM GeneCounts --runThreadN 8 --twopassMode Basic


## single-end mapping

STAR \
--readFilesIn U2OSNT2_1.fastq.gz \
--outSAMattrRGline ID:U2OSNT2 SM:U2OSNT2 PL:ILLUMINA \
--genomeDir /Volumes/LaCie/MAZTER_SEQ/Resources/star_index_2.7.3a \
--genomeLoad NoSharedMemory \
--outFilterMismatchNoverLmax 0.05 \
--outFilterMatchNmin 16 \
--outFilterScoreMinOverLread 0.66 \
--outFilterMatchNminOverLread 0.66 \
--alignIntronMax 300 \
--outFileNamePrefix U2OSNT2_single/U2OSNT2_output_single.0622 \
--readFilesCommand gzcat \
--outSAMtype BAM Unsorted \
--outSAMunmapped Within \
--quantMode TranscriptomeSAM GeneCounts \
--runThreadN 8 \
--twopassMode Basic







## Length adjusted version

for sample in `ls | grep U | awk -F'_' '{print $1}' | uniq`; do mkdir ${sample}; (STAR \
--readFilesIn ${sample}_1.fastq.gz ${sample}_2.fastq.gz \
--outSAMattrRGline ID:${sample} SM:${sample} PL:ILLUMINA \
--genomeDir /data3/MAZTER_SEQ/Resources/STAR_83_index \
--genomeLoad NoSharedMemory \
-–alignIntronMax 300 \
-–alignMatesGapMax 1000 \
--outFileNamePrefix ${sample}/${sample}_output.len_0614 \
--readFilesCommand zcat \
--outSAMtype BAM Unsorted \
--outSAMunmapped Within \
--quantMode TranscriptomeSAM GeneCounts \
--runThreadN 8 \
--twopassMode Basic &) ; done


