#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
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
Seurat.f <- subset(Seurat,subset=SixCellType == "Mono")
Seurat.f <- RunPCA(Seurat.f)
dims <- 1:40
Seurat.f <- RunUMAP(Seurat.f,reduction = "pca",dims = dims,n.neighbors =30)
Seurat.f <- FindNeighbors(Seurat.f,reduction = "pca", dim = dims,k.param = 15)
Seurat.f <- FindClusters(Seurat.f, resolution =0.9)

new.cluster.ids <- as.character(1:length(levels(Seurat.f$seurat_clusters)))
names(new.cluster.ids) <- levels(Seurat.f)
Seurat.f <- RenameIdents(Seurat.f,new.cluster.ids)
Seurat.f$MonoClusterID <- Seurat.f@active.ident
saveRDS(Seurat.f,args[5])


