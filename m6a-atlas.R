options(stringsAsFactors = F)
library(tidyverse)
library(dplyr)

## Got m6A site online data for eukaryote from m6a-atlas : www.xjtlu.edu.cn/biologicalsciences/atlas
atlas = read.table("m6A_Human_Basic_Site_Information.txt")
## Need to convert genome coordinates from hg19 to hg38
colnames(atlas)[3] = "chrom"
atlas = atlas[,2:13]
atlas = atlas[,c(2:4,6,1)]
write.table(atlas, "m6A_Human_Basic_Site_Information.bed",  sep='\t', quote = F, row.names = F, col.names = T)
###### Run Crossmap.py in terminal ###### 

atlas.bed <- as.data.frame(read.table("Hg38.m6A_Human_Basic_Site_Information.bed", header = FALSE, sep="\t", stringsAsFactors=FALSE, quote=""))
colnames(atlas.bed) <- c("chrom", "start", "end", "strand", "m6a_ID")
atlas.bed$seqid = paste(atlas.bed$chrom, atlas.bed$start, sep = ":")


## Load data
d1 = read.delim('Tables/U2OS2-9_output_single.0622Aligned.out.Rdata_clvEffTable.txt') %>% rename_all( ~ paste0(.x, '_KD'))
d2 = read.delim('Tables/U2OSNT2_output_single.0622Aligned.out.Rdata_clvEffTable.txt') %>% rename_all( ~ paste0(.x, '_WT'))

## Filter no cleavage reported
d1 = d1 %>% filter(!is.na(clvEff_5_KD) & !is.na(clvEff_3_KD) & !is.na(avgClvEff_KD))
d2 = d2 %>% filter(!is.na(clvEff_5_WT) & !is.na(clvEff_3_WT) & !is.na(avgClvEff_WT))

## Merge data
d = merge(d1 %>% dplyr::select(-c('X_KD', 'score_KD', 'coorNames_KD', 'seqs_KD')), ## Don't exclude `end` column.
          d2 %>% dplyr::select(-c('X_WT', 'score_WT', 'coorNames_WT', 'seqs_WT')), 
          by.x='name_KD', by.y ='name_WT')

## Calculate the difference: KD - WT
d$avgClvEff_diff = d$avgClvEff_KD - d$avgClvEff_WT
d$transcript_id = do.call(rbind.data.frame, strsplit(d$name_KD, '_', fixed = T))[[1]]

# ## m6a-atlas is based on ENSEMBL Gene ID... Need to add Gene ID to `d` dataframe.
# gm = rtracklayer::import('~/Dropbox/Resources/GENCODE/gencode.v32.primary_assembly.annotation.gtf.gz')
# gm1 = as.data.frame(gm) %>% mutate(tss=ifelse(strand=='+', start, end)) %>% dplyr::select(transcript_id, gene_id, gene_name, tss, gene_type, transcript_type)
# gm1$Ensembl_Gene_ID = do.call(rbind.data.frame, strsplit(gm1$gene_id, '.', fixed = T))[[1]]
# gm1 = gm1 %>% dplyr::select(gene_id, transcript_id, gene_name, transcript_type)
# 
# d_gm1.merged = merge(d, gm1, by = "transcript_id") %>% unique ## 38,752 obs.
# d_gm1.merged$gene_id = do.call(rbind.data.frame, strsplit(d_gm1.merged$gene_id, '.', fixed = T))[[1]]
# 
# d_gm1.merged = d_gm1.merged %>% select(chr_KD, transcript_id, gene_id, start_KD, end_KD, strand_KD, gene_name, transcript_type, avgClvEff_diff, 
#                                        upS_motifDist_KD, doS_motifDist_KD, rE5_KD, rT5_KD, rE3_KD, rT3_KD, clvEff_5_KD, clvEff_3_KD, avgClvEff_KD, 
#                                        upS_motifDist_WT, doS_motifDist_WT, rE5_WT, rT5_WT, rE3_WT, rT3_WT, clvEff_5_WT, clvEff_3_WT, avgClvEff_WT)
# 
# colnames(d_gm1.merged)[1] = "chr"
# colnames(d_gm1.merged)[4:5] = c("start", "end")
# colnames(d_gm1.merged)[6] = "strand"
# 

## How many ACA sites are verified in m6a atlas?
#d_gm1.merged$seqid = paste(d_gm1.merged$chr, d_gm1.merged$start, sep = ":")
d$seqid = paste(d$chr_KD, d$start_KD, sep = ":")
d_atlas = merge(d, atlas.bed, by = "seqid")

d_atlas = d_atlas[,c(35, 31:34, 30, 7:15, 20:29)]
d_atlas = d_atlas[,c(1:6, 25, 8:24)]
write.table(d_atlas, "m6a_atlas_checked_m6aSites_mRNA.txt",  sep='\t', quote = F, row.names = F, col.names = T)




