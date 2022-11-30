#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)
library(cowplot)
library(Seurat)
library(ggplot2)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")
CellType_l <- c("B","TNK","Mono")

data_l <- list()
for (Species in Species_l) {
  data_l[[Species]] <- list()
  for (CellType in CellType_l) {
    data <- readRDS(paste(args[1],Species,"_",CellType,".rds",sep=""))
    data$MockStim <- ifelse(data$Stim == "Mock","Mock","Stim")
    data_l[[Species]][[CellType]] <- data
  }
}


theme_temp <- theme(panel.grid = element_blank(),
                    panel.background=element_rect("white"),
                    axis.line = element_line(size = 0.5, colour = "black"),
                    axis.text = element_text(size = 0, colour = "black"),
                    legend.text = element_text(size = 16, colour = "black"),
                    axis.title = element_text(size = 24, colour = "black"),
                    legend.title = element_text(size = 20, colour = "black")
                    )

p_l <- list()
for (Species in Species_l) {
  p_l[[Species]] <- list()
  for (CellType in CellType_l) {
    UMAP <- data_l[[Species]][[CellType]]
    x_max <- max(UMAP$UMAP_1)
    x_min <- min(UMAP$UMAP_1)
    y_max <- max(UMAP$UMAP_2)
    y_min <- min(UMAP$UMAP_2)
    UMAP.Mock <- UMAP[UMAP$MockStim == "Mock",]
    UMAP.Stim <- UMAP[UMAP$MockStim == "Stim",]
    pm <- ggplot(UMAP.Mock,aes(x=UMAP_1,y=UMAP_2)) + geom_point() + theme_temp
    pm <- pm + scale_x_continuous(limits=c(x_min,x_max)) + scale_y_continuous(limits=c(y_min,y_max))
    ps <- ggplot(UMAP.Stim,aes(x=UMAP_1,y=UMAP_2)) + geom_point() + theme_temp
    ps <- ps + scale_x_continuous(limits=c(x_min,x_max)) + scale_y_continuous(limits=c(y_min,y_max))
    pms <- plot_grid(pm,ps,ncol=2,rel_widths=c(1,1))
    p_l[[Species]][[CellType]] <- pms
  }
}

p2_l <- list()
for (Species in Species_l) {
  pms_l <- p_l[[Species]]
  p2 <- plot_grid(pms_l[["B"]],pms_l[["TNK"]],pms_l[["Mono"]], ncol=3,rel_widths=c(1,1,1))
  p2_l[[Species]] <- p2
}

p <- plot_grid(p2_l[[Species_l[[1]]]],p2_l[[Species_l[[2]]]],p2_l[[Species_l[[3]]]],p2_l[[Species_l[[4]]]],
               ncol=1,rel_heights=c(1,1,1,1))

pdf(args[2],height=8,width=12)
print(p)
dev.off()


