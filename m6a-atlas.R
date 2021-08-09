

## Got m6A site online data for eukaryote from m6a-atlas : www.xjtlu.edu.cn/biologicalsciences/atlas
atlas = read.table("m6A_Human_Basic_Site_Information.txt")
atlas$seqid = paste(atlas$seqnames, atlas$start, sep = ":")

d$seqid = paste(d$chr_KD, d$start_KD, sep = ":")

d_atlas = merge(d, atlas, by = "seqid")

## Load data
d1 = read.delim('Tables/U2OS2-9_output_single.0622Aligned.out.Rdata_clvEffTable.txt') %>% rename_all( ~ paste0(.x, '_KD'))
d2 = read.delim('Tables/U2OSNT2_output_single.0622Aligned.out.Rdata_clvEffTable.txt') %>% rename_all( ~ paste0(.x, '_WT'))

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

## atlas is based on ENSEMBL Gene ID... Need to add Gene ID to `d` dataframe.
gm = rtracklayer::import('~/Dropbox/Resources/gencode.v32.primary_assembly.annotation.gtf.gz')
gm1 = as.data.frame(gm) %>% mutate(tss=ifelse(strand=='+', start, end)) %>% dplyr::select(transcript_id, gene_id, gene_name, tss, gene_type, transcript_type)
gm1$Ensembl_Gene_ID = do.call(rbind.data.frame, strsplit(gm1$gene_id, '.', fixed = T))[[1]]
gm1 = gm1 %>% dplyr::select(gene_id, transcript_id, gene_name, transcript_type)

d$transcript_id = do.call(rbind.data.frame, strsplit(d$name_KD, '_', fixed = T))[[1]]
d_merged = merge(d, gm1, by = "transcript_id") %>% unique ## 38,752 obs.
d_merged$gene_id = do.call(rbind.data.frame, strsplit(d_merged$gene_id, '.', fixed = T))[[1]]

string <- colnames(atlas)
string[10] <- "gene_id"
colnames(atlas) <- string
atlas_gene = as.data.frame(atlas[,10])
colnames(atlas_gene)= "gene_id"

## How many ACA sites are verified in m6a atlas?
d_atlas = merge(d_merged, atlas_gene, by = "gene_id") %>% unique ## 36,485 obs. Good !!
