rm(list = ls())
library(tidyverse)
library(ggplot2)



##### mRNA #####

## Load data
d1 = read.delim('Tables/U2OS2-9_output_single.0622Aligned.out.Rdata_clvEffTable.txt') %>% rename_all( ~ paste0(.x, '_KD'))
d2 = read.delim('Tables/U2OSNT2_output_single.0622Aligned.out.Rdata_clvEffTable.txt') %>% rename_all( ~ paste0(.x, '_WT'))

## Filter no cleavage reported
d1 = d1 %>% filter(!is.na(clvEff_5_KD) & !is.na(clvEff_3_KD) & !is.na(avgClvEff_KD))
d2 = d2 %>% filter(!is.na(clvEff_5_WT) & !is.na(clvEff_3_WT) & !is.na(avgClvEff_WT))

## Load TX annotation
option_tx = F
if (option_tx){
  gm = rtracklayer::import('~/Dropbox/Resources/Gencode_hg38_v32/gencode.v32.primary_assembly.annotation.gtf.gz')
  gm1 = as.data.frame(gm) %>% filter(type=='transcript') %>% mutate(tss=ifelse(strand=='+', start, end)) %>% dplyr::select(transcript_id, gene_id, gene_name, tss, gene_type, transcript_type)
  gm1$transcript_id = do.call(rbind.data.frame, strsplit(gm1$transcript_id, '.', fixed = T))[[1]]
  gm1$gene_id = do.call(rbind.data.frame, strsplit(gm1$gene_id, '.', fixed = T))[[1]]
  saveRDS(gm1, 'Resources/genes.Rdata')
} else{
  gm1 = readRDS('Resources/genes.Rdata')
}

## Merge data
d = merge(d1 %>% 
            dplyr::select(-c('X_KD', 'end_KD', 'score_KD', 'coorNames_KD', 'seqs_KD')), 
          d2 %>% 
            dplyr::select(-c('X_WT', 'end_WT', 'score_WT', 'coorNames_WT', 'seqs_WT')), 
          by.x='name_KD', by.y ='name_WT')

## Calculate the difference: KD - WT
d$avgClvEff_diff = d$avgClvEff_KD - d$avgClvEff_WT

## Calculate the proportion of difference
d %>% filter(!is.na(avgClvEff_diff)) %>% # No NAs in avgClvEff_diff
  group_by(avgClvEff_diff > 0) %>% # Maybe affected by methylation
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

## Calculate the proportion of difference for only protein coding transcripts
tx_coding = gm1 %>% filter(transcript_type=='protein_coding') %>% pull(transcript_id)
#d$transcript_id = do.call(rbind.data.frame, strsplit(d$name_KD, '.', fixed = T))[[1]]
d$transcript_id = do.call(rbind.data.frame, strsplit(d$name_KD, '_', fixed = T))[[1]]


d %>% filter(transcript_id %in% tx_coding) %>%
  filter(!is.na(avgClvEff_diff)) %>%
  group_by(avgClvEff_diff > 0) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

## Visualize the position of ACA sites
# BiocManager::install("Guitar")
library(Guitar)

d1 %>% mutate(start = start_KD - upS_motifDist_KD, 
                     end = start_KD + doS_motifDist_KD,
                     len = end - start) %>%
  filter(!is.na(avgClvEff_KD)) %>%
  dplyr::select(chr=chr_KD, start, end, len, avgClvEff_diff = avgClvEff_KD, strand=strand_KD) %>%
  write.table(., 'Tables/input_U2OS2-9.bed', sep='\t', quote = F, row.names = F, col.names = F)

d2 %>% mutate(start = start_WT - upS_motifDist_WT, 
                     end = start_WT + doS_motifDist_WT,
                     len = end - start) %>%
  filter(!is.na(avgClvEff_WT)) %>%
  dplyr::select(chr=chr_WT, start, end, len, avgClvEff_diff = avgClvEff_WT, strand=strand_WT) %>%
  write.table(., 'Tables/input_U2OSNT2.bed', sep='\t', quote = F, row.names = F, col.names = F)

## Set up the plot 
stBedFiles <- list("Tables/input_U2OS2-9.bed", "Tables/input_U2OSNT2.bed")

library(TxDb.Hsapiens.UCSC.hg38.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene

## Plotting
GuitarPlot(txTxdb = txdb,
           stBedFiles = stBedFiles,
           headOrtail = TRUE,
           enableCI = FALSE,
           mapFilterTranscript = TRUE,
           pltTxType =  c("mrna"),
           stGroupName = c("U2OS2-9", "U2OSNT2"))


##### total #####

## Load data
d1 = read.delim('Tables/U2OS2-9-total_output_single.0622Aligned.out.Rdata_clvEffTable.txt') %>% rename_all( ~ paste0(.x, '_KD'))
d2 = read.delim('Tables/U2OSNT2-total_output_single.0622Aligned.out.Rdata_clvEffTable.txt') %>% rename_all( ~ paste0(.x, '_WT'))

## Filter no cleavage reported
d1 = d1 %>% filter(!is.na(clvEff_5_KD) & !is.na(clvEff_3_KD) & !is.na(avgClvEff_KD))
d2 = d2 %>% filter(!is.na(clvEff_5_WT) & !is.na(clvEff_3_WT) & !is.na(avgClvEff_WT))

## Load TX annotation
option_tx = F
if (option_tx){
  gm = rtracklayer::import('~/Dropbox/Resources/Gencode_hg38_v32/gencode.v32.primary_assembly.annotation.gtf.gz')
  gm1 = as.data.frame(gm) %>% filter(type=='transcript') %>% mutate(tss=ifelse(strand=='+', start, end)) %>% dplyr::select(transcript_id, gene_id, gene_name, tss, gene_type, transcript_type)
  gm1$transcript_id = do.call(rbind.data.frame, strsplit(gm1$transcript_id, '.', fixed = T))[[1]]
  gm1$gene_id = do.call(rbind.data.frame, strsplit(gm1$gene_id, '.', fixed = T))[[1]]
  saveRDS(gm1, 'Resources/genes.Rdata')
} else{
  gm1 = readRDS('Resources/genes.Rdata')
}

## Merge data
d = merge(d1 %>% 
            dplyr::select(-c('X_KD', 'end_KD', 'score_KD', 'coorNames_KD', 'seqs_KD')), 
          d2 %>% 
            dplyr::select(-c('X_WT', 'end_WT', 'score_WT', 'coorNames_WT', 'seqs_WT')), 
          by.x='name_KD', by.y ='name_WT')

## Calculate the difference: KD - WT
d$avgClvEff_diff = d$avgClvEff_KD - d$avgClvEff_WT

## Calculate the proportion of difference
d %>% filter(!is.na(avgClvEff_diff)) %>% # No NAs in avgClvEff_diff
  group_by(avgClvEff_diff > 0) %>% # Maybe affected by methylation
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

## Calculate the proportion of difference for only protein coding transcripts
tx_coding = gm1 %>% filter(transcript_type=='protein_coding') %>% pull(transcript_id)
#d$transcript_id = do.call(rbind.data.frame, strsplit(d$name_KD, '.', fixed = T))[[1]]
d$transcript_id = do.call(rbind.data.frame, strsplit(d$name_KD, '_', fixed = T))[[1]]


d %>% filter(transcript_id %in% tx_coding) %>%
  filter(!is.na(avgClvEff_diff)) %>%
  group_by(avgClvEff_diff > 0) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

## Visualize the position of ACA sites
# BiocManager::install("Guitar")
library(Guitar)

d1 %>% mutate(start = start_KD - upS_motifDist_KD, 
              end = start_KD + doS_motifDist_KD,
              len = end - start) %>%
  filter(!is.na(avgClvEff_KD)) %>%
  dplyr::select(chr=chr_KD, start, end, len, avgClvEff_diff = avgClvEff_KD, strand=strand_KD) %>%
  write.table(., 'Tables/input_U2OS2-9-total.bed', sep='\t', quote = F, row.names = F, col.names = F)

d2 %>% mutate(start = start_WT - upS_motifDist_WT, 
              end = start_WT + doS_motifDist_WT,
              len = end - start) %>%
  filter(!is.na(avgClvEff_WT)) %>%
  dplyr::select(chr=chr_WT, start, end, len, avgClvEff_diff = avgClvEff_WT, strand=strand_WT) %>%
  write.table(., 'Tables/input_U2OSNT2-total.bed', sep='\t', quote = F, row.names = F, col.names = F)

## Set up the plot 
stBedFiles <- list("Tables/input_U2OS2-9-total.bed", "Tables/input_U2OSNT2-total.bed")

library(TxDb.Hsapiens.UCSC.hg38.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene

## Plotting
GuitarPlot(txTxdb = txdb,
           stBedFiles = stBedFiles,
           headOrtail = TRUE,
           enableCI = FALSE,
           mapFilterTranscript = TRUE,
           pltTxType =  c("tx", "mrna", "ncrna"),
           stGroupName = c("U2OS2-9-total", "U2OSNT2-total"))




















