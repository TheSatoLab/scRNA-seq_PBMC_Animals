#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
library(tidyverse)
library(scales)

CellType_l <- c("B_Naive","B_nonNaive","CD4T_Naive","CD4T_nonNaive","CD8T_Naive",
         "CD8T_nonNaive","MAIT","NK","Mono","cDC","pDC")
Colour_l <- hue_pal()(11)
Colours <- c("B_Naive" = Colour_l[1],"B_nonNaive" = Colour_l[2],"CD4T_Naive" = Colour_l[3],"CD4T_nonNaive" = Colour_l[4],
         "CD8T_Naive" = Colour_l[5],"CD8T_nonNaive" = Colour_l[6],"MAIT" = Colour_l[7],"NK" = Colour_l[8],
         "Mono" = Colour_l[9],"cDC" = Colour_l[10],"pDC" = Colour_l[11])
Hs <- readRDS(args[1])
Hs@meta.data <- readRDS(args[2])
ph1 <- DimPlot(Hs,group.by="ClusterLabel",label=T) + NoLegend() + ggtitle("Hs")
Hs@meta.data$CoreClusterLabel <- factor(Hs@meta.data$CoreClusterLabel,level=CellType_l)
ph2 <- DimPlot(Hs,group.by="CoreClusterLabel",label=T,pt.size=1.75,cols=Colours) + ggtitle("Hs")

Pt <- readRDS(args[3])
Pt@meta.data <- readRDS(args[4])
pp1 <- DimPlot(Pt,group.by="ClusterLabel",label=T) + NoLegend() + ggtitle("Pt")
Pt@meta.data$CoreClusterLabel <- factor(Pt@meta.data$CoreClusterLabel,level=CellType_l)
pp2 <- DimPlot(Pt,group.by="CoreClusterLabel",label=T,pt.size=1.75,cols=Colours) + ggtitle("Pt")

Mm <- readRDS(args[5])
Mm@meta.data <- readRDS(args[6])
pm1 <- DimPlot(Mm,group.by="ClusterLabel",label=T) + NoLegend() + ggtitle("Mm")
Mm@meta.data$CoreClusterLabel <- factor(Mm@meta.data$CoreClusterLabel,level=CellType_l)
pm2 <- DimPlot(Mm,group.by="CoreClusterLabel",label=T,pt.size=1.75,cols=Colours) + ggtitle("Mm")

Ra <- readRDS(args[7])
Ra@meta.data <- readRDS(args[8])
pr1 <- DimPlot(Ra,group.by="ClusterLabel",label=T) + NoLegend() + ggtitle("Ra")
Ra@meta.data$CoreClusterLabel <- factor(Ra@meta.data$CoreClusterLabel,level=CellType_l)
pr2 <- DimPlot(Ra,group.by="CoreClusterLabel",label=T,pt.size=1.75,cols=Colours) + ggtitle("Ra")

p1 <- plot_grid(ph1,pp1,pm1,pr1,ncol=2,rel_widths=c(2,2))
pdf(args[9],height=10,width=14)
print(p1)
dev.off()

p2 <- plot_grid(ph2,pp2,pm2,pr2,ncol=2,rel_widths=c(2,2))
pdf(args[10],height=10,width=14)
print(p2)
dev.off()

