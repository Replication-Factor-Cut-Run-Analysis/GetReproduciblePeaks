library(magrittr)
library(ComplexHeatmap)
library(stringr)
library(circlize)

matrix_filename <- snakemake@input[[1]]
colorsForHeatPlot <- stringr::str_split(snakemake@params[[1]],pattern=",") %>% .[[1]]
heatplotBreaks <- stringr::str_split(snakemake@params[[2]],pattern=",") %>% .[[1]] %>% as.numeric
rds_output <- snakemake@output[[1]]
pdf_output <- snakemake@output[[2]]
pdf_width <- snakemake@params[[3]] %>% as.numeric
pdf_height <- snakemake@params[[4]] %>% as.numeric

map_colors<-circlize::colorRamp2(heatplotBreaks,colorsForHeatPlot)

matrix <- read.table(matrix_filename,
                     skip=3,
                     header=F) %>% as.matrix

matrix <- matrix[rev(order(apply(matrix,1,quantile,0.8,na.rm=TRUE))),]

names <- read.table(matrix_filename,skip=2,nrow=1)[1,-1] %>% 
  as.character %>%
  gsub("_bkgrndNorm","",.)

htmp <- ComplexHeatmap::Heatmap(
  matrix,
  cluster_columns = FALSE,
  cluster_rows=FALSE,
  show_column_names = FALSE,
  show_row_names=FALSE,
  column_split = names,
  col=map_colors,
  column_title_gp = gpar(fontsize = 8),
  heatmap_legend_param = list(
    title = "Log2FC",
    labels_gp = gpar(fontsize = 6),
    title_gp = gpar(fontsize = 8)
))

saveRDS(htmp,rds_output)
#pdf(file = pdf_output, width = pdf_width, height = pdf_height)
pdf(file = pdf_output)
htmp
dev.off()
