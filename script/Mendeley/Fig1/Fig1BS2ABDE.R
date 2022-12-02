#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(tidyverse)

CellType_l <- c("B_Naive","B_nonNaive","CD4T_Naive","CD4T_nonNaive","CD8T_Naive","CD8T_nonNaive","MAIT","NK","Mono","cDC","pDC")
data_l <- list()

Seurat <- readRDS(args[1])
mt <- readRDS(args[2])
mt$CellType <- factor(mt$CoreClusterLabel,level=CellType_l)
mt$Species <- "Hs"
mt$CellID <- paste("Hs",rownames(mt),sep="_")
mt$ClusterID <- mt$BasicClusterID
mt <- cbind(mt,Seurat@reductions$umap@cell.embeddings)
mt <- mt[,c("CellID","Species","Stim","CellType","UMAP_1","UMAP_2","ClusterID","predicted.id","predicted.id.score","mapping.score")]
data_l[["Hs"]] <- mt

Seurat <- readRDS(args[3])
mt <- readRDS(args[4])
mt$CellType <- factor(mt$CoreClusterLabel,level=CellType_l)
mt$Species <- "Pt"
mt$CellID <- paste("Pt",rownames(mt),sep="_")
mt$ClusterID <- mt$BasicClusterID
mt <- cbind(mt,Seurat@reductions$umap@cell.embeddings)
mt <- mt[,c("CellID","Species","Stim","CellType","UMAP_1","UMAP_2","ClusterID","predicted.id","predicted.id.score","mapping.score")]
data_l[["Pt"]] <- mt

Seurat <- readRDS(args[5])
mt <- readRDS(args[6])
mt$CellType <- factor(mt$CoreClusterLabel,level=CellType_l)
mt$Species <- "Mm"
mt$CellID <- paste("Mm",rownames(mt),sep="_")
mt$ClusterID <- mt$BasicClusterID
mt <- cbind(mt,Seurat@reductions$umap@cell.embeddings)
mt <- mt[,c("CellID","Species","Stim","CellType","UMAP_1","UMAP_2","ClusterID","predicted.id","predicted.id.score","mapping.score")]
data_l[["Mm"]] <- mt

Seurat <- readRDS(args[7])
mt <- readRDS(args[8])
mt$CellType <- factor(mt$CoreClusterLabel,level=CellType_l)
mt$Species <- "Ra"
mt$CellID <- paste("Ra",rownames(mt),sep="_")
mt$ClusterID <- mt$BasicClusterID
mt <- cbind(mt,Seurat@reductions$umap@cell.embeddings)
mt <- mt[,c("CellID","Species","Stim","CellType","UMAP_1","UMAP_2","ClusterID","predicted.id","predicted.id.score","mapping.score")]
data_l[["Ra"]] <- mt

data <- rbind(data_l$Hs,data_l$Pt,data_l$Mm,data_l$Ra)

combined <- readRDS(args[9])
mtm <- combined@meta.data
mtm$CellID <- paste(mtm$Species,mtm$Stim,gsub("^.._","",rownames(mtm)),sep="_")
mtm <- cbind(mtm,combined@reductions$umap@cell.embeddings)
mtm <- select(mtm,CellID,UMAP_1,UMAP_2,MergeCluster)
colnames(mtm) <- c("CellID","MockMerge_UMAP_1","MockMerge_UMAP_2","MockMergeClusterID")

out <- left_join(data,mtm,by="CellID")
write.table(out,args[10],row.names=F,sep="\t",quote=F)

