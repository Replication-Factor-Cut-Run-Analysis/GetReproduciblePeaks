library(magrittr)
library(eulerr)
library(GenomicRanges)
library(ggplotify)
library(stringr)

input <- readRDS(snakemake@input[[1]])
output <- snakemake@output[[1]]
eulerFontSize <- snakemake@params[[1]]
eulerFills <- snakemake@params[[2]]

fills <- stringr::str_split(eulerFills,pattern=",") %>% .[[1]]

eulerr_options(labels = list(fontsize = eulerFontSize),
               quantities = list(fontsize = eulerFontSize-2),
               legend = list(fontsize = eulerFontSize, vgap = 0.01))
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

saveRDS(EulerPlot,output)
