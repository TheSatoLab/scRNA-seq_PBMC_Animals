#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)
library(Seurat)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")
CellType_l <- c("B","TNK","Mono")

data_l <- list()
for (Species in Species_l) {
  if (Species == "Homo_sapiens") sp <- "Hs"
  if (Species == "Pan_troglodytes") sp <- "Pt"
  if (Species == "Macaca_mulatta") sp <- "Mm"
  if (Species == "Rousettus_aegyptiacus") sp <- "Ra"
  data_l[[sp]] <- list()
  for (CellType in CellType_l) {
    data <- readRDS(paste(args[1],Species,"_",CellType,".rds",sep=""))
    data$MockStim <- ifelse(data$Stim == "Mock","Mock","Stim")
    data$CellID <- paste(sp,rownames(data),sep="_")
    data$Species <- sp
    data$CellType <- CellType
    data <- data %>% select(CellID,Species,Stim,MockStim,CellType,UMAP_1,UMAP_2)
    data_l[[sp]][[CellType]] <- data
  }
  data_l[[sp]] <- rbind(data_l[[sp]][["B"]],data_l[[sp]][["TNK"]],data_l[[sp]][["Mono"]])
}
out <- rbind(data_l[[1]],data_l[[2]],data_l[[3]],data_l[[4]])
write.table(out,args[2],sep="\t",quote=F,row.names=F)



