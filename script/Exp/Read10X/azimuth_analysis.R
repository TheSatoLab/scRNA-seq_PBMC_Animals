#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(Azimuth)
source("Exp/Azimuth/azimuth_base.R")
reference <- readRDS(args[2])
if (args[1] == "Homo_sapiens") {
  query <- readRDS(args[3])
} else {
  query <- readRDS(args[4])
}

cells.use <- query[["nCount_RNA", drop = TRUE]] <= 25000 &
  query[["nCount_RNA", drop = TRUE]] >= 1200 &
  query[["nFeature_RNA", drop = TRUE]] <= 5000 &
  query[["nFeature_RNA", drop = TRUE]] >= 800
query <- query[, cells.use]
query <- Azimuth(query,reference,"celltype.l2")
query@active.assay <- "prediction.score.celltype.l2"
query@assays$RNA <- NULL
query@assays$refAssay <- NULL
query@assays$impADT <- NULL
query@reductions$integrated_dr <- NULL
saveRDS(query,args[5])
saveRDS(query@meta.data,args[6])

