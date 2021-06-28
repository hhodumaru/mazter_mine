## bam2ReadEnds
Rscript bam2ReadEnds_SE.R -i bamfile -g /Volumes/LaCie/MAZTER_SEQ/Resources/hg38_v32_SYKedit.bed
## mazter_mine
Rscript mazter_mine.R -i Rdata -g /Volumes/LaCie/MAZTER_SEQ/Resources/hg38_v32_SYKedit.bed \
-f /Volumes/LaCie/MAZTER_SEQ/Resources/GRCh38.v32.primary_assembly.genome.fa -u 60 -d 60
