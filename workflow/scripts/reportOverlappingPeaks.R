# Script name: reportOverlappingPeaks
# Author:  Chris Sansam
# Date Created:  8-22-22
# Purpose: This script takes in a merged peaks file and a parameter
#          containing a list of additional peak files. It filters the 
#          merged peaks file to remove peaks that overlap with blacklisted
#          regions. It then calculates the overlap between each peak file 
#          in the input parameter and the filtered merged peaks, and stores 
#          the resulting overlap information as metadata in the merged peaks 
#          object. Finally, the merged peaks object is saved in RDS format 
#          as the output file.

# Load necessary packages
library(magrittr)
library(GenomicRanges)
library(stringr)

# Get input and output files and parameter
merged_peaks_file <- snakemake@input[[1]] # Input merged peaks file
output <- snakemake@output[[1]] # Output file
peak_files_input <- snakemake@params[[1]] # Input peak files parameter

# Read in blacklist regions file and convert to GRanges object
blacklist_regions_file <- snakemake@input[[2]]
blacklisted_regions <- blacklist_regions_file %>%
  read.table(.,sep="\t") %>%
  GenomicRanges::makeGRangesFromDataFrame(.,
                                          ignore.strand = T,
                                          seqnames.field = "V1",
                                          start.field = "V2",
                                          end.field = "V3")

# Read in merged peaks file and convert to GRanges object, then filter to remove any peaks that overlap with blacklisted regions
merged_peaks <- merged_peaks_file %>%
  read.table %>%
  GenomicRanges::makeGRangesFromDataFrame(.,
                                          ignore.strand = T,
                                          seqnames.field = "V1",
                                          start.field = "V2",
                                          end.field = "V3") %>%
  .[!. %over% blacklisted_regions]

# Process each peak file in input parameter
overlaps <- peak_files_input %>%
  stringr::str_split(.,pattern=",") %>% # Split input parameter by comma
  .[[1]] %>% # Extract first element (i.e., the filenames)
  lapply(.,read.table) %>% # Read in each peak file
  magrittr::set_names(stringr::str_split(peak_files_input,pattern=",") %>%
                        .[[1]] %>%
                        gsub("^.*/","",.) %>%
                        gsub("_peaks.narrowPeak","",.) %>%
                        gsub("_(?=[^_]*$).*","",.,perl=T)) %>% # Extract sample names from filenames
  lapply(.,GenomicRanges::makeGRangesFromDataFrame,
         ignore.strand = T,
         seqnames.field = "V1",
         start.field = "V2",
         end.field = "V3") %>% # Convert each peak file to GRanges object
  lapply(.,function(gr){merged_peaks %over% gr}) %>% # Calculate overlap between each peak file and merged peaks
  do.call(cbind,.) # Convert list of overlaps to matrix

# Add overlaps matrix as metadata to merged peaks object
GenomicRanges::mcols(merged_peaks) <- overlaps
  
# Save merged peaks object in RDS format
saveRDS(merged_peaks,file=output)


