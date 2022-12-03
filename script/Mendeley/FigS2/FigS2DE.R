#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(tidyverse)
Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
CellType_l <- c("B_Naive","B_nonNaive","CD4T_Naive","CD4T_nonNaive","CD8T_Naive","CD8T_nonNaive","MAIT","NK","Mono","cDC","pDC")
data_l <- list()

for (Species in Species_l) {
  if (Species == "Homo_sapiens")          sp <- "Hs"
  if (Species == "Pan_troglodytes")       sp <- "Pt"
  if (Species == "Macaca_mulatta")        sp <- "Mm"
  if (Species == "Rousettus_aegyptiacus") sp <- "Ra"
  Seurat <- readRDS(paste(args[1],Species,"/",Species,".rds",sep=""))
  mt <- readRDS(paste(args[1],Species,"/",Species,"_metadata.rds",sep=""))
  mt$CellType <- factor(mt$CoreClusterLabel,level=CellType_l)
  mt$Species <- sp
  mt$CellID <- paste(sp,rownames(mt),sep="_")
  mt$ClusterID <- mt$BasicClusterID
  mt <- cbind(mt,Seurat@reductions$umap@cell.embeddings)
  mt <- mt[,c("CellID","Species","Stim","CellType","ClusterID")]
  mt <- mt[mt$Stim == "Mock",]
  data_l[[sp]] <- mt
}

data <- rbind(data_l[[1]],data_l[[2]],data_l[[3]],data_l[[4]])

combined <- readRDS(args[2])
mtm <- combined@meta.data
mtm$CellID <- paste(mtm$Species,mtm$Stim,gsub("^.._","",rownames(mtm)),sep="_")
mtm <- cbind(mtm,combined@reductions$umap@cell.embeddings)
mtm <- select(mtm,CellID,UMAP_1,UMAP_2,MergeCluster)
colnames(mtm) <- c("CellID","MockMerge_UMAP_1","MockMerge_UMAP_2","MockMergeClusterID")

out <- left_join(data,mtm,by="CellID")
write.table(out,args[3],row.names=F,sep="\t",quote=F)

