#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
library(ggplot2)

Seurat <- readRDS(args[1])
SCT <- readRDS(args[2])
Seurat@assays$SCT <- SCT
Seurat@active.assay <- "SCT"
mt <- readRDS(args[3])
Seurat@meta.data <- mt
Seurat@assays$dummy <- NULL

Seurat.f <- Seurat
Seurat.f@graphs <- list()
Seurat.f@commands <- list()
Seurat.f@tools <- list()
Seurat.f@reductions <- list()
Seurat.f <- subset(Seurat.f,subset=CoreClusterLabel != "Others")
Seurat.f$CoreClusterLabel_rev <- factor(Seurat.f$CoreClusterLabel,level=rev(levels(Seurat.f$CoreClusterLabel)))


features <- unique(c(
              "CD79A","CD79B","MS4A1","TCL1A", #B naive
              "TNFRSF13B","BANK1", #B intermediate
              "CD3E",
              "CD4","TCF7","CCR7","LEF1","PIK3IP1", #CD4 Naive
              "CD4","ITGB1","TRAC", #CD4 nonNaive
              "CD8A","CD8B","LEF1", #CD8T Naive
              "TRAC","CCL5","TRGC2", #CD8T nonNaive
              "KLRB1","GZMK", #MAIT
              "NKG7","GNLY","TRDC","PRF1", #NK
              "MAFB","CD14","LYZ","IL1B","FCGR3A","LST1", #Mono
              "CD1C","CCDC88A","FLT3","FCER1A", #cDC
              "ITM2C","IL3RA","SPIB" #pDC
              ))

ortho <- read.table(args[5],header=T,sep="\t")
if (args[4] == "Homo_sapiens")          sp <- "Hs"
if (args[4] == "Pan_troglodytes")       sp <- "Pt"
if (args[4] == "Macaca_mulatta")        sp <- "Mm"
if (args[4] == "Rousettus_aegyptiacus") sp <- "Ra"
ortho.f <- ortho[,c("Hs",sp)]
colnames(ortho.f) <- c("Hs","sp")
ortho.ff <- ortho.f[ortho.f$Hs %in% features,]
ortho.ff$Hs <- factor(ortho.ff$Hs,level=features)
ortho.ff <- ortho.ff[order(ortho.ff$Hs),]
ortho.ff <- na.omit(ortho.ff)
features <- ortho.ff$sp

p <- DotPlot(Seurat.f,features = features,group.by="CoreClusterLabel_rev",assay="SCT")
p <- p + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
p <- p + ggtitle(args[4])
pdf(args[6],height=4,width=10)
print(p)
dev.off()


