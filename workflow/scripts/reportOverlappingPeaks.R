## ---------------------------
##
## Script name: reportOverlappingPeaks
##
## Purpose of script: Make an .rds with GRanges of merged peaks with overlaps of each indivisual peak set scored in mcols
##
## Author: Chris Sansam
##
## Date Created: 2022-08-22
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

library(magrittr)
library(GenomicRanges)
library(stringr)

merged_peaks_file <- snakemake@input[[1]]
output <- snakemake@output[[1]]
peak_files_input <- snakemake@params[[1]]
blacklist_regions_file <- snakemake@params[[2]]

blacklisted_regions <- blacklist_regions_file %>%
  read.table %>%
  GenomicRanges::makeGRangesFromDataFrame(.,
                                          ignore.strand = T,
                                          seqnames.field = "V1",
                                          start.field = "V2",
                                          end.field = "V3")

merged_peaks <- merged_peaks_file %>%
  read.table %>%
  GenomicRanges::makeGRangesFromDataFrame(.,
                                          ignore.strand = T,
                                          seqnames.field = "V1",
                                          start.field = "V2",
                                          end.field = "V3") %>%
  .[!. %over% blacklisted_regions]

overlaps <- peak_files_input %>%
  stringr::str_split(.,pattern=",") %>% 
  .[[1]] %>%
  lapply(.,read.table) %>%
  magrittr::set_names(stringr::str_split(peak_files_input,pattern=",") %>%
                        .[[1]] %>%
                        gsub("^.*/","",.) %>%
                        gsub("_peaks.narrowPeak","",.) %>%
                        gsub("_(?=[^_]*$).*","",.,perl=T)) %>%
  lapply(.,GenomicRanges::makeGRangesFromDataFrame,
         ignore.strand = T,
         seqnames.field = "V1",
         start.field = "V2",
         end.field = "V3") %>%
  lapply(.,function(gr){merged_peaks %over% gr}) %>%
  do.call(cbind,.)

GenomicRanges::mcols(merged_peaks) <- overlaps
  
saveRDS(merged_peaks,file=output)
