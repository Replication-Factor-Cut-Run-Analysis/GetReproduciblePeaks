library(stringr)
library(magrittr)
library(dplyr)
library(GenomicRanges)
library(GreyListChIP)

mergedInputBam_file <- snakemake@input[[1]]
greyList_output <- snakemake@output[[1]]
greyBlackList_output <- snakemake@output[[2]]
blacklist_regions_file <- snakemake@params[[1]]
BSGenomePackage <- snakemake@params[[2]]

library(BSGenomePackage,character.only = TRUE)

blacklisted_regions <- blacklist_regions_file %>%
  read.table(.,sep="\t") %>%
  GenomicRanges::makeGRangesFromDataFrame(.,
                                          ignore.strand = T,
                                          seqnames.field = "V1",
                                          start.field = "V2",
                                          end.field = "V3")

gl <- greyListBS(get(BSGenomePackage),mergedInputBam_file) 

export(gl,con=greyBlackList_output)

c(gl,blacklisted_regions) %>%
  reduce %>%
  data.frame(
    seqnames=seqnames(.),
    starts=start(.)-1,
    ends=end(.)) %>%
  write.table(
    ., 
    file=greyBlackList_output, 
    quote=F, 
    sep="\t", 
    row.names=F, 
    col.names=F)
