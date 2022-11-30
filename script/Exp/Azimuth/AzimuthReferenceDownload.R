#!/usr/bin/env R

library(Seurat)
library(Azimuth)
args <- commandArgs(T)

reference <- LoadReference(path = "https://seurat.nygenome.org/azimuth/references/v1.0.0/human_pbmc")
saveRDS(reference,args[1])


