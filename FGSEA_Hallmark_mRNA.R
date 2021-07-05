options(stringsAsFactors = F)
library(readxl)
library(tidyverse)
library(dplyr)
library(writexl)
library(AnnotationDbi)
library(org.Hs.eg.db)
library(fgsea)

pp <- fgsea::gmtPathways('Resources/h.all.v7.4.symbols.gmt')


## Load data
d1 = read.delim('Data_distance_30/U2OS2-9_output_single.0622Aligned.out.Rdata_clvEffTable.txt') %>% rename_all( ~ paste0(.x, '_KD'))
d2 = read.delim('Data_distance_30/U2OSNT2_output_single.0622Aligned.out.Rdata_clvEffTable.txt') %>% rename_all( ~ paste0(.x, '_WT'))

## Filter no cleavage reported
d1 = d1 %>% filter(!is.na(clvEff_5_KD) & !is.na(clvEff_3_KD) & !is.na(avgClvEff_KD))
d2 = d2 %>% filter(!is.na(clvEff_5_WT) & !is.na(clvEff_3_WT) & !is.na(avgClvEff_WT))

## Merge data
d = merge(d1 %>% 
            dplyr::select(-c('X_KD', 'end_KD', 'score_KD', 'coorNames_KD', 'seqs_KD')), 
          d2 %>% 
            dplyr::select(-c('X_WT', 'end_WT', 'score_WT', 'coorNames_WT', 'seqs_WT')), 
          by.x='name_KD', by.y ='name_WT')

## Calculate the difference: KD - WT
d$avgClvEff_diff = d$avgClvEff_KD - d$avgClvEff_WT
d$transcript_id = do.call(rbind.data.frame, strsplit(d$name_KD, '_', fixed = T))[[1]]

## Load TX annotation
option_tx = F
if (option_tx){
  gm = rtracklayer::import('~/Dropbox/Resources/Gencode_hg38_v32/gencode.v32.primary_assembly.annotation.gtf.gz')
  gm1 = as.data.frame(gm) %>% filter(type=='transcript') %>% mutate(tss=ifelse(strand=='+', start, end)) %>% dplyr::select(transcript_id, gene_id, gene_name, tss, gene_type, transcript_type)
  gm1$transcript_id = do.call(rbind.data.frame, strsplit(gm1$transcript_id, '.', fixed = T))[[1]]
  gm1$gene_id = do.call(rbind.data.frame, strsplit(gm1$gene_id, '.', fixed = T))[[1]]
  saveRDS(gm1, 'genes.Rdata')
} else{
  gm1 = readRDS('Resources/genes.Rdata')
}

gm1 = gm1 %>% dplyr::select(transcript_id, gene_name, transcript_type)
d = d %>% dplyr::select(transcript_id, avgClvEff_diff)
d_merged = merge(d, gm1, by = "transcript_id") %>% dplyr::select(avgClvEff_diff, gene_name) %>% unique
d_merged$abs_avgClvEff_diff <- abs(d_merged$avgClvEff_diff)
d_merged_abs = d_merged %>% group_by(gene_name) %>% filter(abs_avgClvEff_diff == max(abs_avgClvEff_diff))

##abs value
gg = d_merged_abs %>% dplyr::select(gene_name, abs_avgClvEff_diff) %>% unique
gg = gg[order(gg$abs_avgClvEff_diff),]
gg1 = gg %>% pull(abs_avgClvEff_diff)
names(gg1) <- gg %>% pull(gene_name) %>% toupper()

df = fgsea(pathways = pp, stats = gg1, scoreType = "pos", eps = 0)
df = df[order(df$NES), ]
df$leadingEdge <- vapply(df$leadingEdge, paste, collapse = ", ", character(1L))
df = df %>% arrange(padj)
write.table(df, paste("Tables/table_fgsea_gmt.h.all_mRNA_abs.0705.txt", sep = "_"), quote=F, sep='\t', row.names = F, col.names = T)
write_xlsx(df, paste("Tables/table_fgsea_gmt.h.all_mRNA_abs.0705.xlsx", sep = "_"), col_names = T)

plotEnrichment(pp[["HALLMARK_MITOTIC_SPINDLE"]], gg1) + labs(title = "HALLMARK_MITOTIC_SPINDLE")

# dfRes = df %>% dplyr::filter(padj <= 0.1 & size >= 10)
# dfRes = dfRes[order(dfRes$NES), ]
# dfRes$leadingEdge <- vapply(dfRes$leadingEdge, paste, collapse = ", ", character(1L))
# dfRes = dfRes %>% arrange(padj)
# write.table(dfRes, paste("Tables/table_fgsea_gmt.h.all_mRNA_abs.0705.txt", sep = "_"), quote=F, sep='\t', row.names = F, col.names = T)

## non-abs value
gg = d_merged_abs %>% dplyr::select(gene_name, avgClvEff_diff) %>% unique
gg = gg[order(gg$avgClvEff_diff),]
gg1 = gg %>% pull(avgClvEff_diff)
names(gg1) <- gg %>% pull(gene_name) %>% toupper()

df = fgsea(pathways = pp, stats = gg1, scoreType = "pos", eps = 0)
df = df[order(df$NES), ]
df$leadingEdge <- vapply(df$leadingEdge, paste, collapse = ", ", character(1L))
df = df %>% arrange(padj)
write.table(df, paste("Tables/table_fgsea_gmt.h.all_mRNA_non.abs.0705.txt", sep = "_"), quote=F, sep='\t', row.names = F, col.names = T)
write_xlsx(df, paste("Tables/table_fgsea_gmt.h.all_mRNA_non.abs.0705.xlsx", sep = "_"), col_names = T)







