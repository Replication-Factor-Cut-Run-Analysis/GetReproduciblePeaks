library(magrittr)
library(eulerr)
library(GenomicRanges)
library(ggplotify)
library(stringr)

input <- readRDS(snakemake@input[[1]])
output <- snakemake@output[[1]]
pdf_output <- snakemake@output[[2]]
eulerFontSize <- snakemake@params[[1]]
eulerFills <- snakemake@params[[2]]
pdf_width <- snakemake@params[[3]] %>% as.numeric
pdf_height <- snakemake@params[[4]] %>% as.numeric

fills <- stringr::str_split(eulerFills,pattern=",") %>% .[[1]]

eulerr_options(labels = list(fontsize = eulerFontSize),
               quantities = list(fontsize = eulerFontSize-2,
                                padding = grid::unit(100, "mm")),
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

pdf(pdf_output,width=pdf_width,height=pdf_height)
EulerPlot
dev.off()
