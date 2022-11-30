#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
library(future)
plan("multicore",workers=8)
options(future.globals.maxSize = 16000000000)
set.seed(1)

Seurat <- readRDS(args[1])
integrated <- readRDS(args[2])
Seurat@assays$integrated <- integrated
Seurat@active.assay <- "integrated"
SCT <- readRDS(args[3])
Seurat@assays$SCT <- SCT
mt <- readRDS(args[4])
Seurat@meta.data <- mt

dummy <- Seurat@assays$dummy
Seurat@assays$dummy <- NULL

if (args[5] == "B") Seurat.c <- subset(Seurat,subset=SixCellType == "B")
if (args[5] == "TNK") Seurat.c <- subset(Seurat,subset=SixCellType == "NaiveT" | SixCellType == "KillerTNK")
if (args[5] == "Mono") Seurat.c <- subset(Seurat,subset=SixCellType == "Mono")
Seurat.c <- RunPCA(Seurat.c)
dims <- 1:40
Seurat.c <- RunUMAP(Seurat.c,reduction = "pca",dims = dims,n.neighbors =30)

data.c <- Seurat.c@reductions$umap@cell.embeddings
mt.c <- Seurat.c@meta.data
out <- cbind(data.c,mt.c)
saveRDS(out,args[6])

