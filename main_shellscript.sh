## bam2ReadEnds
Rscript bam2ReadEnds_SE.R -i bamfile -g /Volumes/LaCie/MAZTER_SEQ/Resources/hg38_v32_SYKedit.bed
## mazter_mine
Rscript mazter_mine.R -i Rdata -g /Volumes/LaCie/MAZTER_SEQ/Resources/hg38_v32_SYKedit.bed \
-f /Volumes/LaCie/MAZTER_SEQ/Resources/GRCh38.v32.primary_assembly.genome.fa -u 60 -d 60



for sample in `ls | grep U | awk -F'_' '{print $1}' | uniq`; do (Rscript bam2ReadEnds_SE.R -i ${sample}/${sample}_output_single_hg19.0810Aligned.out.bam -g /data2/MAZTER_SEQ/hg38_v32_SYKedit.bed &) ; done