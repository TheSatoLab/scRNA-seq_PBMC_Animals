#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(GSVA)

Seurat <- readRDS(args[1])
mt <- Seurat@meta.data
ortho <- read.table(args[3],header=T,sep="\t")
DEG.df <- read.table(args[4], header=T, check.names=F)
DEG5.df <- DEG.df[DEG.df$Cluster == "5",]
DEG7.df <- DEG.df[DEG.df$Cluster == "7",]
ortho.DEG5 <- ortho[ortho$Ra %in% DEG5.df$gene,]
ortho.DEG7 <- ortho[ortho$Ra %in% DEG7.df$gene,]
sp <- switch(
    args[2],
    "Homo_sapiens" = "Hs",
    "Pan_troglodytes" = "Pt",
    "Macaca_mulatta" = "Mm",
    "Rousettus_aegyptiacus" = "Ra",
    "Others"
)

data <- Seurat@assays$SCT@data
data <- data[rowSums(data) != 0,]
ortho.f <- ortho[,c("Hs",sp)]
colnames(ortho.f) <- c("Hs","sp")
ortho.f <- ortho.f[ortho.f$sp %in% rownames(data),]
data.f <- data[rownames(data) %in% ortho.f$sp,]
DEG5.f <- ortho.DEG5[ortho.DEG5[,sp] %in% rownames(data),]
DEG7.f <- ortho.DEG7[ortho.DEG7[,sp] %in% rownames(data),]

input <- as.matrix(log10(data.f + 1))
ModuleScore <- gsva(input, list(C5marker = DEG5.f[,sp],C7marker = DEG7.f[,sp]),
  mx.diff=TRUE,verbose=F,parallel.sz=8,min.sz=10,max.sz=500,method="ssgsea")
mt.o <- cbind(mt,t(ModuleScore))
saveRDS(mt.o,args[5])

