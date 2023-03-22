###############################################
# Script name: makeEulerOfOverlappingPeaks.R   
# Author: Chris Sansam                        
# Date created: 8/22/22                        
# Purpose: Generate an Euler plot of overlapping peaks that have been merged.
# Input is an RDS file containing the merged peaks with scores 
# indicating overlap with each of the replicate peak sets
# Output is an RDS and PDF file with a plot. Parameters
# specified in Snakemake file. Script uses eulerr, GenomicRanges, ggplotify,
# and stringr.                          
###############################################

# Load required packages.
library(magrittr)
library(eulerr)
library(GenomicRanges)
library(ggplotify)
library(stringr)

# Load input and output files and parameters from Snakemake.
input <- readRDS(snakemake@input[[1]])
output <- snakemake@output[[1]]
pdf_output <- snakemake@output[[2]]
eulerFontSize <- snakemake@params[[1]]
eulerFills <- snakemake@params[[2]]
pdf_width <- snakemake@params[[3]] %>% as.numeric
pdf_height <- snakemake@params[[4]] %>% as.numeric

# Split fills by commas to create a vector of fills.
fills <- stringr::str_split(eulerFills,pattern=",") %>% .[[1]]

# Set options for the Euler plot.
eulerr_options(labels = list(fontsize = eulerFontSize),
               quantities = list(fontsize = eulerFontSize-2,
                                padding = grid::unit(100, "mm")),
               legend = list(fontsize = eulerFontSize, vgap = 0.01))

# Create the Euler plot.
EulerPlot <- GenomicRanges::mcols(input) %>%
    as.matrix %>%
    euler(
      .,
      shape="ellipse") %>%
    plot(
      .,
      quantities=TRUE,
      legend=TRUE,
      adjust_labels=TRUE,
      fills=fills) %>%
    as.ggplot

# Save the Euler plot as an RDS file.
saveRDS(EulerPlot,output)

# Save the Euler plot as a PDF file.
pdf(pdf_output,width=pdf_width,height=pdf_height)
EulerPlot
dev.off()
