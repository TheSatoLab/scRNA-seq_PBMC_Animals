#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(GSVA)
library(tidyverse)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
mt_l <- list()

ortho <- read.table(args[1],header=T,sep="\t")
ortho.m <- na.omit(ortho)
for (Species in Species_l) {
  mt <- readRDS(paste(args[2],Species,"/",Species,"_metadata.rds",sep=""))
  mt$ID <- paste(Species,rownames(mt),sep="__")
  mt$Species <- Species
  mt <- mt %>% select(ID,Species,Stim,SixCellType)
  mt_l[[Species]] <- mt
  sp <- switch(Species,"Homo_sapiens"="Hs","Pan_troglodytes"="Pt",
                       "Macaca_mulatta"="Mm","Rousettus_aegyptiacus"="Ra","NA")
  SCT_All <- readRDS(paste(args[2],Species,"/",Species,"_SCT.rds",sep=""))
  data <- SCT_All@data
  data.f <- data[rownames(data) %in% ortho.m[,sp],]
  colnames(data.f) <- paste(Species,colnames(data.f),sep="__")
  ortho.m <- merge(ortho.m,data.f,by.x=sp,by.y=0)
}
mt <- rbind(mt_l[[1]],mt_l[[2]],mt_l[[3]],mt_l[[4]])

ISG <- read.table(args[3], header=T, check.names=F)
ISG.f <- ISG[ISG$gene %in% ortho.m$Hs,]

rownames(ortho.m) <- ortho.m$Hs
input <- select(ortho.m,-Hs,-Pt,-Mm,-Ra)

GSVA_score <- gsva(as.matrix(log10(input + 1)), list(ISG = ISG.f),
  mx.diff=TRUE,verbose=F,parallel.sz=40,min.sz=10,max.sz=500,method="ssgsea")

mt$ISG <- GSVA_score["ISG",]
saveRDS(mt,args[4])


