#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(ggplot2)
library(cowplot)
library(tidyverse)
library(Seurat)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")
CellType_l <- c("B","NaiveT","KillerTNK","Mono","cDC","pDC")
colours <- c("B" = "pink","NaiveT" = "skyblue","KillerTNK" = "greenyellow","Mono" = "orange","cDC" = "orangered","pDC" = "gold3")

p_l <- list()
for (Species in Species_l) {
  mt <- readRDS(paste(args[1],Species,"_metadata_SensorGenes.rds",sep=""))
  mt <- mt[,c("SixCellType","TLR3","TLR4")]
  mt <- mt[mt$SixCellType != "Others",]
  mt$CellType <- factor(mt$SixCellType, level = CellType_l)
  TLR3 <- ggplot(mt,aes(x = CellType, y = TLR3, fill = CellType)) + geom_violin() + scale_fill_manual(values=colours)
  TLR3 <- TLR3 + ylim(0,2)
  p_l[[Species]] <- TLR3
}

p <- plot_grid(p_l[[1]],p_l[[2]],p_l[[3]],p_l[[4]],ncol=4,rel_widths=c(1,1,1,1))

pdf(args[2],height=4,width=16)
print(p)
dev.off()



