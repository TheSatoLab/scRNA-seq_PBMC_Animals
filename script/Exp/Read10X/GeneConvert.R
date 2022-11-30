#!/usr/bin/env R

library(Seurat)
args <- commandArgs(trailingOnly=T)

data <- readRDS(args[3])
mt <- data@meta.data
counts <- data@assays$RNA@counts
ortho <- read.table(args[4],header=T,sep="\t")
if (args[1] == "Homo_sapiens") sp <- "Hs"
if (args[1] == "Pan_troglodytes") sp <- "Pt"
if (args[1] == "Macaca_mulatta") sp <- "Mm"
if (args[1] == "Rousettus_aegyptiacus") sp <- "Ra"
ortho <- ortho[,c("Hs",sp)]
colnames(ortho) <- c("Hs","sp")
ortho.f <- ortho[ortho$sp %in% rownames(counts),]
counts.f <- counts[rownames(counts) %in% ortho.f$sp,]
ortho.f$sp <- factor(ortho.f$sp,level=rownames(counts.f))
ortho.s <- ortho.f[order(ortho.f$sp),]
rownames(counts.f) <- ortho.s$Hs
Seurat <- CreateSeuratObject(counts = counts.f,
    project = paste(args[1],args[2],sep="_"),meta.data=mt)
Seurat$Stim <- args[2]
saveRDS(Seurat,args[5])

