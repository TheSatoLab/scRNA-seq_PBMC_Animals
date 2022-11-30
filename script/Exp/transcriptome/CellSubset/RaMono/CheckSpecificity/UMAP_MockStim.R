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
  UMAP.C5.Mock <- UMAP.C5[UMAP.C5$MockStim == "Mock",]
  UMAP.C7.Mock <- UMAP.C7[UMAP.C7$MockStim == "Mock",]
  UMAP.ISG.Mock <- UMAP.ISG[UMAP.ISG$MockStim == "Mock",]
  UMAP.C5.Stim <- UMAP.C5[UMAP.C5$MockStim == "Stim",]
  UMAP.C7.Stim <- UMAP.C7[UMAP.C7$MockStim == "Stim",]
  UMAP.ISG.Stim <- UMAP.ISG[UMAP.ISG$MockStim == "Stim",]
  pC5m <- ggplot(UMAP.C5.Mock,aes(x=UMAP_1,y=UMAP_2,col=C5marker)) + geom_point()
  pC5m <- pC5m + scale_colour_gradient2(low="blue",mid="gray85",high="red",midpoint=0,limits=c(-max_C5,max_C5)) + theme_bw()
  pC5s <- ggplot(UMAP.C5.Stim,aes(x=UMAP_1,y=UMAP_2,col=C5marker)) + geom_point()
  pC5s <- pC5s + scale_colour_gradient2(low="blue",mid="gray85",high="red",midpoint=0,limits=c(-max_C5,max_C5)) + theme_bw()
  pC7m <- ggplot(UMAP.C7.Mock,aes(x=UMAP_1,y=UMAP_2,col=C7marker)) + geom_point()
  pC7m <- pC7m + scale_colour_gradient2(low="blue",mid="gray85",high="red",midpoint=0,limits=c(-max_C7,max_C7)) + theme_bw()
  pC7s <- ggplot(UMAP.C7.Stim,aes(x=UMAP_1,y=UMAP_2,col=C7marker)) + geom_point()
  pC7s <- pC7s + scale_colour_gradient2(low="blue",mid="gray85",high="red",midpoint=0,limits=c(-max_C7,max_C7)) + theme_bw()
  pISGm <- ggplot(UMAP.ISG.Mock,aes(x=UMAP_1,y=UMAP_2,col=ISG)) + geom_point()
  pISGm <- pISGm + scale_colour_gradient2(low="blue",mid="gray85",high="red",midpoint=0,limits=c(-max_ISG,max_ISG)) + theme_bw()
  pISGs <- ggplot(UMAP.ISG.Stim,aes(x=UMAP_1,y=UMAP_2,col=ISG)) + geom_point()
  pISGs <- pISGs + scale_colour_gradient2(low="blue",mid="gray85",high="red",midpoint=0,limits=c(-max_ISG,max_ISG)) + theme_bw()
  ps <- plot_grid(pMockStim,pC5m,pC5s,pC7m,pC7s,pISGm,pISGs,ncol=7,rel_widths=c(1.5,1.2,1.2,1.2,1.2,1.2,1.2))
  p_l[[Species]] <- ps
}

p <- plot_grid(p_l[[Species_l[[1]]]],p_l[[Species_l[[2]]]],p_l[[Species_l[[3]]]],p_l[[Species_l[[4]]]],
               ncol=1,rel_heights=c(1,1,1,1))

pdf(args[3],height=10,width=22)
print(p)
dev.off()


