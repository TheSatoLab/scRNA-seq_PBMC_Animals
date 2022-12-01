#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(tidyverse)


Colours <-  c("B_Naive" = "plum","B_nonNaive" = "pink1","CD4T_Naive" = "cyan","CD4T_nonNaive" = "deepskyblue2",
         "CD8T_Naive" = "aquamarine","CD8T_nonNaive" = "aquamarine3","MAIT" = "olivedrab3","NK" = "green",
         "Mono" = "orange","cDC" = "orangered","pDC" = "gold3")

CellType_l <- c("B_Naive","B_nonNaive","CD4T_Naive","CD4T_nonNaive","CD8T_Naive","CD8T_nonNaive","MAIT","NK","Mono","cDC","pDC")

data_l <- list()

Seurat <- readRDS(args[1])
mt <- readRDS(args[2])
mt$CellType <- factor(mt$CoreClusterLabel,level=CellType_l)
mt$Species <- "Hs"
mt$CellID <- paste("Hs",rownames(mt),sep="_")
mt <- cbind(mt,Seurat@reductions$umap@cell.embeddings)
mt <- mt[,c("CellID","Species","Stim","CellType","UMAP_1","UMAP_2")]
data_l[["Hs"]] <- mt

Seurat <- readRDS(args[3])
mt <- readRDS(args[4])
mt$CellType <- factor(mt$CoreClusterLabel,level=CellType_l)
mt$Species <- "Pt"
mt$CellID <- paste("Pt",rownames(mt),sep="_")
mt <- cbind(mt,Seurat@reductions$umap@cell.embeddings)
mt <- mt[,c("CellID","Species","Stim","CellType","UMAP_1","UMAP_2")]
data_l[["Pt"]] <- mt

Seurat <- readRDS(args[5])
mt <- readRDS(args[6])
mt$CellType <- factor(mt$CoreClusterLabel,level=CellType_l)
mt$Species <- "Mm"
mt$CellID <- paste("Mm",rownames(mt),sep="_")
mt <- cbind(mt,Seurat@reductions$umap@cell.embeddings)
mt <- mt[,c("CellID","Species","Stim","CellType","UMAP_1","UMAP_2")]
data_l[["Mm"]] <- mt

Seurat <- readRDS(args[7])
mt <- readRDS(args[8])
mt$CellType <- factor(mt$CoreClusterLabel,level=CellType_l)
mt$Species <- "Ra"
mt$CellID <- paste("Ra",rownames(mt),sep="_")
mt <- cbind(mt,Seurat@reductions$umap@cell.embeddings)
mt <- mt[,c("CellID","Species","Stim","CellType","UMAP_1","UMAP_2")]
data_l[["Ra"]] <- mt

data <- rbind(data_l$Hs,data_l$Pt,data_l$Mm,data_l$Ra)
write.table(data,args[9],row.names=F,sep="\t",quote=F)

