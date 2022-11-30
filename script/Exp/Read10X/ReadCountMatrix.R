#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)

counts <- Read10X_h5(args[1])
Seurat <- CreateSeuratObject(counts = counts,project = args[2],
                                 min.cells = 0, min.features = 500)

saveRDS(Seurat,args[3])
saveRDS(Seurat@meta.data,args[4])

