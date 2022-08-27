library(bamsignals)
library(parallel)
library(GenomicRanges)
library(magrittr)
library(GreyListChIP)
library(dplyr)

mergedInputBam_file <- snakemake@input[[1]]
greyList_output <- snakemake@output[[1]]
greyBlackList_output <- snakemake@output[[2]]
blacklist_regions_file <- snakemake@params[[1]]
BSGenomePackage <- snakemake@params[[2]]
mapqual <- snakemake@params[[3]]
procs <- snakemake@params[[4]]

library(BSGenomePackage,character.only = TRUE)

blacklisted_regions <- blacklist_regions_file %>%
  read.table(.,sep="\t") %>%
  GenomicRanges::makeGRangesFromDataFrame(.,
                                          ignore.strand = T,
                                          seqnames.field = "V1",
                                          start.field = "V2",
                                          end.field = "V3")

#########
# set a greylist object
gl <- new("GreyList")

# this tiles the genome, removing all chromosomes with the "_" character. if your genome has these, you should change this
gl@tiles <- get(BSGenomePackage) %>%
  SeqinfoForBSGenome %>%
  GRanges %>%
  .[grep("_|chrM",seqnames(.),invert=TRUE)] %>%
  tile(.,width = 1000) %>%
  unlist
  
processByChromosome <- function(bam.file, gr, mapqual, procs) {
  mclapply(
    gr %>% seqnames %>% unique %>% as.character,
    function(chunk){
      gr2 <- gr[ seqnames(gr) %in% chunk] 
      gr2$counts <- gr2 %>%
        bamCount(bam.file,.,verbose=FALSE)
      return(gr2)
    }
  ) %>%
    do.call(c,.)
}

gr_counts <- processByChromosome(bam.file=mergedInputBam_file, 
                                 gr=gl@tiles, 
                                 mapqual=mapqual, 
                                 procs=procs)

gl@tiles <- gr_counts
gl@counts <- gr_counts$counts

gl <- calcThreshold(gl,reps=10,sampleSize=1000,p=0.99,cores=procs)

gl <- makeGreyList(gl,maxGap=10000)

export(gl,con=greyBlackList_output)

class(gl)
class(blacklisted_regions)

c(unlist(gl),unlist(blacklisted_regions)) %>%
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
