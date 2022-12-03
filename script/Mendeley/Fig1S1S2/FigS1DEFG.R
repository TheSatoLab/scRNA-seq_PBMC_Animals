#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")

data_l <- list()

for (Species in Species_l) {
  if (Species == "Homo_sapiens")          sp <- "Hs"
  if (Species == "Pan_troglodytes")       sp <- "Pt"
  if (Species == "Macaca_mulatta")        sp <- "Mm"
  if (Species == "Rousettus_aegyptiacus") sp <- "Ra"
  for (Stim in Stim_l) {
    before <- readRDS(paste(args[1],Species,"_",Stim,"_","metadata.rds",sep=""))
    after <- readRDS(paste(args[2],Species,"_",Stim,"_","metadata.rds",sep=""))
    before$status <- ifelse(rownames(before) %in% rownames(after),"used","eliminated")
    before$Species <- Species
    before$Stim <- Stim
    before$CellID <- paste(sp,Stim,rownames(before),sep="_")
    data <- before[,c("CellID","Species","Stim","status","nFeature_RNA","nCount_RNA")]
    data_l[[sp]][[Stim]] <- data
  }
  data_l[[sp]] <- rbind(data_l[[sp]][[1]],data_l[[sp]][[2]],data_l[[sp]][[3]],data_l[[sp]][[4]])
}
out <- rbind(data_l[[1]],data_l[[2]],data_l[[3]],data_l[[4]])
write.table(out,args[3],sep="\t",quote=F,row.names=F)



