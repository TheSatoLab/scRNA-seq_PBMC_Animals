#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
library(tidyverse)


Colours <-  c("B_Naive" = "plum","B_nonNaive" = "pink1","CD4T_Naive" = "cyan","CD4T_nonNaive" = "deepskyblue2",
         "CD8T_Naive" = "aquamarine","CD8T_nonNaive" = "aquamarine3","MAIT" = "olivedrab3","NK" = "green",
         "Mono" = "orange","cDC" = "orangered","pDC" = "gold3")

CellType_l <- c("B_Naive","B_nonNaive","CD4T_Naive","CD4T_nonNaive","CD8T_Naive","CD8T_nonNaive","MAIT","NK","Mono","cDC","pDC")
pt.size <- 0.5

Hs <- readRDS(args[1])
Hs@meta.data <- readRDS(args[2])
Hs@meta.data$CoreClusterLabel <- factor(Hs@meta.data$CoreClusterLabel,level=CellType_l)
ph2 <- DimPlot(Hs,group.by="CoreClusterLabel",pt.size=pt.size,cols=Colours) + ggtitle("Hs")

Pt <- readRDS(args[3])
Pt@meta.data <- readRDS(args[4])
Pt@meta.data$CoreClusterLabel <- factor(Pt@meta.data$CoreClusterLabel,level=CellType_l)
pp2 <- DimPlot(Pt,group.by="CoreClusterLabel",pt.size=pt.size,cols=Colours) + ggtitle("Pt")

Mm <- readRDS(args[5])
Mm@meta.data <- readRDS(args[6])
Mm@meta.data$CoreClusterLabel <- factor(Mm@meta.data$CoreClusterLabel,level=CellType_l)
pm2 <- DimPlot(Mm,group.by="CoreClusterLabel",pt.size=pt.size,cols=Colours) + ggtitle("Mm")

Ra <- readRDS(args[7])
Ra@meta.data <- readRDS(args[8])
Ra@meta.data$CoreClusterLabel <- factor(Ra@meta.data$CoreClusterLabel,level=CellType_l)
pr2 <- DimPlot(Ra,group.by="CoreClusterLabel",pt.size=pt.size,cols=Colours) + ggtitle("Ra")


p2 <- plot_grid(ph2,pp2,pm2,pr2,ncol=4,rel_widths=c(1,1,1,1))
pdf(args[9],height=4,width=22)
print(p2)
dev.off()

