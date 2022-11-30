#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)
library(cowplot)
library(Seurat)
library(ggplot2)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")
Mono_l <- list()
UMAP_l <- list()
max_C5 <- 0
max_C7 <- 0
max_ISG <- 0

for (Species in Species_l) {
  Mono <- readRDS(paste(args[1],Species,".rds",sep=""))
  mt <- readRDS(paste(args[2],Species,".rds",sep=""))
  Mono@meta.data <- mt
  Mono$MockStim <- ifelse(Mono$Stim == "Mock","Mock","Stim")
  Mono_l[[Species]] <- Mono
  
  UMAP <- as.data.frame(Mono@reductions$umap@cell.embeddings)
  UMAP$MockStim <- Mono$MockStim
  UMAP$C5marker <- scale(Mono$C5marker,scale=F)
  UMAP$C7marker <- scale(Mono$C7marker,scale=F)
  UMAP$ISG <- scale(Mono$CoreISGmam,scale=F)
  UMAP_l[[Species]] <- UMAP
  
  max_C5 <- max(max_C5,max(UMAP$C5marker))
  max_C7 <- max(max_C7,max(UMAP$C7marker))
  max_ISG <- max(max_ISG,max(UMAP$ISG))
}

p_l <- list()
for (Species in Species_l) {
  Mono <- Mono_l[[Species]]
  pMockStim <- DimPlot(Mono,reduction="umap",split.by="MockStim")
  UMAP <- UMAP_l[[Species]]
  UMAP.C5 <- UMAP[order(UMAP$C5marker),]
  UMAP.C7 <- UMAP[order(UMAP$C7marker),]
  UMAP.ISG <- UMAP[order(UMAP$ISG),]
  pC5 <- ggplot(UMAP.C5,aes(x=UMAP_1,y=UMAP_2,col=C5marker)) + geom_point()
  pC5 <- pC5 + scale_colour_gradient2(low="blue",mid="gray85",high="red",midpoint=0,limits=c(-max_C5,max_C5)) + theme_bw()
  pC7 <- ggplot(UMAP.C7,aes(x=UMAP_1,y=UMAP_2,col=C7marker)) + geom_point()
  pC7 <- pC7 + scale_colour_gradient2(low="blue",mid="gray85",high="red",midpoint=0,limits=c(-max_C7,max_C7)) + theme_bw()
  pISG <- ggplot(UMAP.ISG,aes(x=UMAP_1,y=UMAP_2,col=ISG)) + geom_point()
  pISG <- pISG + scale_colour_gradient2(low="blue",mid="gray85",high="red",midpoint=0,limits=c(-max_ISG,max_ISG)) + theme_bw()
  ps <- plot_grid(pMockStim,pC5,pC7,pISG,ncol=4,rel_widths=c(1.5,1.2,1.2,1.2))
  p_l[[Species]] <- ps
}

p <- plot_grid(p_l[[Species_l[[1]]]],p_l[[Species_l[[2]]]],p_l[[Species_l[[3]]]],p_l[[Species_l[[4]]]],
               ncol=1,rel_heights=c(1,1,1,1))

pdf(args[3],height=10,width=14)
print(p)
dev.off()


