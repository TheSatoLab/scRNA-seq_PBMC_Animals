#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)
library(Seurat)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")
data_l <- list()

for (Species in Species_l) {
  Mono <- readRDS(paste(args[1],Species,".rds",sep=""))
  mt <- readRDS(paste(args[2],Species,".rds",sep=""))
  mt$MockStim <- ifelse(Mono$Stim == "Mock","Mock","Stim")
  mt <- cbind(mt,as.data.frame(Mono@reductions$umap@cell.embeddings))
  mt$C7marker.minus_avg <- scale(mt$C7marker,scale=F)
  mt$Species <- Species
  data_l[[Species]] <- mt
}
data_l$Homo_sapiens$CellID <- paste("Hs",rownames(data_l$Homo_sapiens),sep="_")
data_l$Pan_troglodytes$CellID <- paste("Pt",rownames(data_l$Pan_troglodytes),sep="_")
data_l$Macaca_mulatta$CellID <- paste("Mm",rownames(data_l$Macaca_mulatta),sep="_")
data_l$Rousettus_aegyptiacus$CellID <- paste("Ra",rownames(data_l$Rousettus_aegyptiacus),sep="_")
out <- rbind(data_l[[1]],data_l[[2]],data_l[[3]],data_l[[4]])
out <- out %>% select(CellID,Species,Stim,MockStim,MonoClusterID,UMAP_1,UMAP_2,C7marker,C7marker.minus_avg)
write.table(out,args[3],sep="\t",quote=F,row.names=F)




