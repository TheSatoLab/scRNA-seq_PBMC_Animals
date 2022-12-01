#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)
library(cowplot)
library(Seurat)
library(ggplot2)
library(scales)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")
Mono_l <- list()
UMAP_l <- list()
max_C5 <- 0
max_C7 <- 0

for (Species in Species_l) {
  Mono <- readRDS(paste(args[1],Species,".rds",sep=""))
  mt <- readRDS(paste(args[2],Species,".rds",sep=""))
  Mono@meta.data <- mt
  Mono$MockStim <- ifelse(Mono$Stim == "Mock","Mock","Stim")
  Mono_l[[Species]] <- Mono
  
  UMAP <- as.data.frame(Mono@reductions$umap@cell.embeddings)
  UMAP$MockStim <- Mono$MockStim
  UMAP$clusterID <- Mono$MonoClusterID
  UMAP$C5marker <- scale(Mono$C5marker,scale=F)
  UMAP$C7marker <- scale(Mono$C7marker,scale=F)
  UMAP_l[[Species]] <- UMAP
  
  max_C5 <- max(max_C5,max(UMAP$C5marker))
  max_C7 <- max(max_C7,max(UMAP$C7marker))
}

theme_temp <- theme(panel.grid = element_blank(),
                    panel.background=element_rect("white"),
                    axis.line = element_line(size = 0.5, colour = "black"),
                    axis.text = element_text(size = 32, colour = "black"),
                    legend.text = element_text(size = 16, colour = "black"),
                    axis.title = element_text(size = 24, colour = "black"),
                    legend.title = element_text(size = 20, colour = "black")
                    )

p_l <- list()
for (Species in Species_l) {
  Mono <- Mono_l[[Species]]
  if (Species == "Homo_sapiens") {
    breaks_x <- c(-4,0,4)
    breaks_y <- c(-4,-2,0,2)
  } else if (Species == "Pan_troglodytes") {
    breaks_x <- c(-3,0,3,6)
    breaks_y <- c(-3,0,3,6)
  } else if (Species == "Macaca_mulatta") {
    breaks_x <- c(-3,0,3,6)
    breaks_y <- c(-4,0,4)
  } else {
    breaks_x <- c(-2,0,2,4)
    breaks_y <- c(-3,0,3)
  }
  UMAP <- UMAP_l[[Species]]
  x_max <- max(UMAP$UMAP_1)
  x_min <- min(UMAP$UMAP_1)
  y_max <- max(UMAP$UMAP_2)
  y_min <- min(UMAP$UMAP_2)
  UMAP.Mock <- UMAP[UMAP$MockStim == "Mock",]
  UMAP.Stim <- UMAP[UMAP$MockStim == "Stim",]

  pMock <- ggplot(UMAP.Mock,aes(x=UMAP_1,y=UMAP_2,col=clusterID)) + geom_point() + theme_temp
  pMock <- pMock + scale_x_continuous(breaks = breaks_x,limits=c(x_min,x_max)) + scale_y_continuous(breaks = breaks_y,limits=c(y_min,y_max))
  pMock <- pMock + scale_color_manual(values=hue_pal()(7))
  pStim <- ggplot(UMAP.Stim,aes(x=UMAP_1,y=UMAP_2,col=clusterID)) + geom_point() + theme_temp
  pStim <- pStim + scale_x_continuous(breaks = breaks_x,limits=c(x_min,x_max)) + scale_y_continuous(breaks = breaks_y,limits=c(y_min,y_max))
  pStim <- pStim + scale_color_manual(values=hue_pal()(7))

  UMAP.C5 <- UMAP[order(UMAP$C5marker),]
  UMAP.C7 <- UMAP[order(UMAP$C7marker),]
  pC5 <- ggplot(UMAP.C5,aes(x=UMAP_1,y=UMAP_2,col=C5marker)) + geom_point() + theme_temp
  pC5 <- pC5 + scale_colour_gradientn(colours=c("blue","gray","gray","red"),limits=c(-max_C5,max_C5))
  pC5 <- pC5 + scale_x_continuous(breaks = breaks_x,limits=c(x_min,x_max)) + scale_y_continuous(breaks = breaks_y,limits=c(y_min,y_max))
  pC7 <- ggplot(UMAP.C7,aes(x=UMAP_1,y=UMAP_2,col=C7marker)) + geom_point() + theme_temp
  pC7 <- pC7 + scale_colour_gradientn(colours=c("blue","gray","gray","red"),limits=c(-max_C7,max_C7),breaks=c(-0.7,-0.35,0,0.35,0.7))
  pC7 <- pC7 + scale_x_continuous(breaks = breaks_x,limits=c(x_min,x_max)) + scale_y_continuous(breaks = breaks_y,limits=c(y_min,y_max))
  ps <- plot_grid(pMock,pStim,pC5,pC7,ncol=4,rel_widths=c(1,1,1,1))
  p_l[[Species]] <- ps
}

p <- plot_grid(p_l[[Species_l[[1]]]],p_l[[Species_l[[2]]]],p_l[[Species_l[[3]]]],p_l[[Species_l[[4]]]],
               ncol=1,rel_heights=c(1,1,1,1))

pdf(args[3],height=12,width=17)
print(p)
dev.off()


