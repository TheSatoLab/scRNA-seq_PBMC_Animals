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

RowCluster_level <- c(
  "B_Naive","B_nonNaive","Plasmablast",
  "CD4T_Naive","CD4TCM","CD4_CTL","Treg","CD4T_nonNaive",
  "CD8T_Naive","CD8T_nonNaive",
  "MAIT","gdT","dnT","NK",
  "Mono1","Mono2","cDC","pDC","Others"
  )

Seurat$ClusterLabel_rev <- factor(Seurat$ClusterLabel,level=rev(RowCluster_level))

features <- unique(c("CD79A","CD79B","IL4R","MS4A1","CXCR4","TCL1A","YBX3", #B naive
              "TNFRSF13B","AIM2","LINC01857","RALGPS2","BANK1", #B intermediate
              "COCH","SSPN","TEX9","TNFRSF13C","LINC01781", #B memory
              "IGHA2","MZB1","TNFRSF17","DERL3","POU2AF1","CPNE5","HRASLS2", #plasmablast
              "CD3E",
              "CD4","TCF7","CCR7","IL7R","FHIT","LEF1","MAL","NOSIP","LDHB","PIK3IP1", #CD4 Naive
              "IL7R","CD4","ITGB1","LTB","TRAC","AQP3","LDHB","IL32","MAL", #CD4 TCM
              "IL7R","CCL5","FYB1","GZMK","IL32","KLRB1","TRAC","LTB","AQP3", #CD4 TEM
              "RTKN2","FOXP3","AC133644.2","IL2RA","TIGIT","CTLA4","FCRL3","LAIR2","IKZF", # Treg
              "CD8A","CD8B","S100B","RGS10","NOSIP","LINC02446","LEF1","CRTAM","OXNAD1", #CD8T Naive
              "ANXA1","KRT1","LINC02446","YBX3","IL7R","TRAC","NELL2","LDHB", #CD8 TCM
              "CCL5","GZMH","KLRD1","CST7","TRGC2", #CD8T TEM
              "KLRB1","GZMK","IL7R","SLC4A10","GZMA","CXCR6","PRSS35","RBM24","NCR3", #MAIT
              "NKG7","GNLY","TYROBP","FCER1G","GZMB","TRDC","PRF1","FGFBP2","SPON2","KLRF1", #NK
              "MAFB","CD14","S100A9","CTSS","S100A8","LYZ","VCAN","S100A12","IL1B","G0S2","FCN1", #cMono
              "FCGR3A","CDKN1C","LST1","IER5","MS4A7","RHOC","IFITM3","AIF1","HES4", #ncMono
              "CD1C","CD74","CCDC88A","CST3","CLEC9A","DNASE1L3","IDO1","FLT3","NDRG2","FCER1A","CLEC10A","ENHO","PLD4","GSN","SLC38A1","AFF3", #cDC
              "ITM2C","IL3RA","MZB1","SPIB","SMPD3" #pDC
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

p <- DotPlot(Seurat,features = features,group.by="ClusterLabel_rev",assay="SCT")
p <- p + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
p <- p + ggtitle(args[4])
pdf(args[6],height=7,width=20)
print(p)
dev.off()

