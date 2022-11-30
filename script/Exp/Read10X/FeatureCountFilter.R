#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
options(future.globals.maxSize = 32000000000)

raw <- readRDS(args[1])
mt.a <- readRDS(args[2])
mt.a <- mt.a[mt.a$predicted.celltype.l2 != "Eryth",]
mt.a <- mt.a[mt.a$predicted.celltype.l2 != "HSPC",]
mt.a <- mt.a[mt.a$predicted.celltype.l2 != "ILC",]
mt.a <- mt.a[mt.a$predicted.celltype.l2 != "Platelet",]
raw.f <- raw[,colnames(raw) %in% rownames(mt.a)]
raw.f$logCount.scale <- scale(log(raw.f$nCount_RNA))
raw.f$logFeature.scale <- scale(log(raw.f$nFeature_RNA))
Seurat <- subset(raw.f,
  subset = logCount.scale <= 3 & logCount.scale >= -3 
         & logFeature.scale <=  3 & logFeature.scale >= -3)
mt <- Seurat@meta.data
mt.fil <- mt[,c("orig.ident","nCount_RNA","nFeature_RNA")]
Seurat@meta.data <- mt.fil
Seurat$Stim <- args[3]
saveRDS(Seurat,args[4])
saveRDS(Seurat@meta.data,args[5])

