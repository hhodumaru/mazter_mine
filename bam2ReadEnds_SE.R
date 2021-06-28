#!/usr/bin/env Rscript
# Title: Start-End Paired BED genomic to transcriptomic exon annotation already generated ########
# Author: Miguel Angel Garcia-Campos https://github.com/AngelCampos ############

#install.packages("optparse", lib = "/usr/local/lib/R/site-library/")
library("optparse")
library("plyr")
library("dplyr")

# Parsing Arguments ############################################################
option_list = list(
  make_option(c("-i", "--BAMfile"), type="character", default = NULL,
              help="BAM alignment file", metavar="character"),
  make_option(c("-g", "--geneAnnotation"), type="character", default = NULL,
              help="Gene annotation file in BED-12 format", metavar="character"),
  make_option(c("-l", "--maxInsLen"), type="integer", default = 200,
              help="Maximum mapped insert length [default= %default]", metavar="numeric"),
  make_option(c("-m", "--minInsG"), type="integer", default = 15,
              help="Minimum number of inserts to report gene [default= %default]", metavar="numeric"),
  make_option(c("-n", "--nCores"), type="integer", default = 2,
              help="Number of cores to be used [default= %default]", metavar="numeric")
)
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser)

nCores <- 2
BAMfile <- opt$BAMfile
geneAnnotation <- opt$geneAnnotation
maxInsertLength <- opt$maxInsLen
minIns <- opt$minInsG

#Functions #####################################################################
source("https://raw.githubusercontent.com/hhodumaru/mazter_mine/master/helperFunctions_SE.R")

# Packages #####################################################################
#CRAN packages
CRAN_packs <- c("magrittr", "parallel", "optparse")
sapply(CRAN_packs, function(x) installLoad_CRAN(x))

# MAIN program #################################################################
# Create bed paired end alignment ####
BEDPfile <- tempfile()
comm <- paste0("samtools view -bq 5 -F 4 ", BAMfile," | bedtools bamtobed -i stdin | cut -f1-3,6 > ", BEDPfile)
system(command = comm, wait = T)

# Annotation file ####

#geneAnnot <- readBED(geneAnnotation)

###################################################################
## Modified the upper code (line 46) because of the duplicated rows - SYK,0510
readBED_SYK <- function(fileName, idAsRowNames = T){
  tmp <- read.delim(fileName, header = F, stringsAsFactors = F)
  tmp <- tmp %>% distinct(V4, .keep_all = TRUE) # hg38_v32 : 100360 -> 100291
  tmp[,2] <- tmp[,2] + 1
  colnames(tmp)[1:6] <- c("chr", "start", "end", "id", "score", "strand")
  tmp$strand <- as.character(tmp$strand)
  tmp$chr <- as.character(tmp$chr)
  if(idAsRowNames){rownames(tmp) <- tmp$id}
  return(tmp)
}
geneAnnot <- readBED_SYK(geneAnnotation)
####################################################################

colnames(geneAnnot) <- c("chr", "start", "end", "name", "score", "strand", 
                         "startCodon", "stopCodon", "itemRGB", "blockCount", 
                         "blockSizes", "blockStarts")
rownames(geneAnnot) <- geneAnnot$name

# Process sample ####
cl <- makeCluster(nCores, type = "FORK")
procSample <- singleEndReadsToGenes(cl, bedPEGzFile = BEDPfile, gAnnot = geneAnnot)
stopCluster(cl)

# Get count data ####
cl <- makeCluster(nCores, type = "FORK")
countData <- getCountData(cluster = cl, 
                          dat = procSample, 
                          GENES = names(procSample),
                          geneAnnot = geneAnnot, 
                          minInserts = minIns,
                          maxInsLen = maxInsertLength) 
stopCluster(cl)
names(countData) <- names(procSample)
tmpSel <- sapply(countData, function(x) length(x$cov)) > 1
countData <- countData[tmpSel]

# Save Rdata object ############################################################
newFileName <- gsub(pattern = ".bam", replacement =  ".Rdata", x = BAMfile)
save(countData, file = newFileName)
#file.remove(BEDPfile) #remove bedPfile
