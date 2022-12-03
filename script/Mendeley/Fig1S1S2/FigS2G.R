#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(ggplot2)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
features <- unique(c("CD79A","CD79B","MS4A1","TCL1A","TNFRSF13B","BANK1",
              "CD3E","CD4","TCF7","CCR7","LEF1","PIK3IP1","CD4","ITGB1","TRAC",
              "CD8A","CD8B","LEF1","TRAC","CCL5","TRGC2","KLRB1","GZMK","NKG7","GNLY","TRDC","PRF1",
              "MAFB","CD14","LYZ","IL1B","FCGR3A","LST1","CD1C","CCDC88A","FLT3","FCER1A","ITM2C","IL3RA","SPIB"))
ortho <- read.table(args[2],header=T,sep="\t")
data_l <- list()
for (Species in Species_l) {
  Seurat <- readRDS(paste(args[1],Species,"/",Species,".rds",sep=""))
  SCT <- readRDS(paste(args[1],Species,"/",Species,"_SCT.rds",sep=""))
  Seurat@assays$SCT <- SCT
  Seurat@active.assay <- "SCT"
  mt <- readRDS(paste(args[1],Species,"/",Species,"_metadata.rds",sep=""))
  Seurat@meta.data <- mt
  Seurat@assays$dummy <- NULL
  Seurat@graphs <- list()
  Seurat@commands <- list()
  Seurat@tools <- list()
  Seurat@reductions <- list()
  Seurat <- subset(Seurat,subset=CoreClusterLabel != "Others")
  Seurat$CoreClusterLabel_rev <- factor(Seurat$CoreClusterLabel,level=rev(levels(Seurat$CoreClusterLabel)))
  if (Species == "Homo_sapiens")          sp <- "Hs"
  if (Species == "Pan_troglodytes")       sp <- "Pt"
  if (Species == "Macaca_mulatta")        sp <- "Mm"
  if (Species == "Rousettus_aegyptiacus") sp <- "Ra"
  ortho.f <- ortho[,c("Hs",sp)]
  colnames(ortho.f) <- c("Hs","sp")
  ortho.ff <- ortho.f[ortho.f$Hs %in% features,]
  ortho.ff$Hs <- factor(ortho.ff$Hs,level=features)
  ortho.ff <- ortho.ff[order(ortho.ff$Hs),]
  ortho.ff <- na.omit(ortho.ff)
  features.sp <- ortho.ff$sp

  p <- DotPlot(Seurat,features = features.sp,group.by="CoreClusterLabel_rev",assay="SCT")
  data <- p$data
  data$Species <- sp
  data_l[[sp]] <- data
}
out <- rbind(data_l[[1]],data_l[[2]],data_l[[3]],data_l[[4]])
out <- out[,c("Species","features.plot","id","avg.exp","avg.exp.scaled","pct.exp")]
colnames(out) <- c("Species","gene","CellType","avg.exp","avg.exp.scaled","pct.exp")
write.table(out,args[3],sep="\t",quote=F,row.names=F)


