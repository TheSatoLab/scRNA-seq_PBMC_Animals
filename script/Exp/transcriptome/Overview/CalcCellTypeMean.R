#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(future)
plan("multicore",workers=8)
options(future.globals.maxSize = 16000000000)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")
Cell_l <- c("B_Naive","B_nonNaive",
  "CD4T_Naive","CD4T_nonNaive","CD8T_Naive","CD8T_nonNaive","MAIT","NK",
  "Mono","cDC","pDC")

########################################################################
###Scaling
########################################################################
SCTscale_l <- list()
ExpSum_l <- list()
for (Species in Species_l) {
  Seurat <- readRDS(paste(args[1],Species,"/",Species,".rds",sep=""))
  SCT_All <- readRDS(paste(args[1],Species,"/",Species,"_SCT.rds",sep=""))
  Seurat@assays$SCT <- SCT_All
  Seurat@assays$dummy <- NULL
  Seurat@active.assay <- "SCT"
  SCTscale_l[[Species]] <- Seurat@assays$SCT@data
  ExpSum <- rowSums(Seurat@assays$SCT@data)
  ExpSum_l[[Species]] <- ExpSum
}

########################################################################
###Extract Orthologous Genes
########################################################################
ortho <- read.table(args[2],header=T,sep="\t")
ortho <- ortho[ortho$Hs %in% rownames(SCTscale_l[["Homo_sapiens"]]),]
ortho <- ortho[ortho$Pt %in% rownames(SCTscale_l[["Pan_troglodytes"]]),]
ortho <- ortho[ortho$Mm %in% rownames(SCTscale_l[["Macaca_mulatta"]]),]
ortho <- ortho[ortho$Ra %in% rownames(SCTscale_l[["Rousettus_aegyptiacus"]]),]
gene_order <- ortho$Hs

DataOrtho_l <- list()
ExpSumOrtho_l <- list()
for (Species in Species_l) {
  if (Species == "Homo_sapiens") sp <- "Hs"
  if (Species == "Pan_troglodytes") sp <- "Pt"
  if (Species == "Macaca_mulatta") sp <- "Mm"
  if (Species == "Rousettus_aegyptiacus") sp <- "Ra"
  data.s <- as.data.frame(SCTscale_l[[Species]])
  ExpSum <- ExpSum_l[[Species]]
  data.s$ExpSum <- ExpSum
  data.m <- merge(ortho,data.s,by.x=sp,by.y=0)
  data.m$Hs <- factor(data.m$Hs,level = gene_order)
  rownames(data.m) <- data.m$Hs
  data.o <- data.m[order(data.m$Hs),]
  ExpSumOrtho <- data.o$ExpSum
  names(ExpSumOrtho) <- rownames(data.o)
  ExpSumOrtho_l[[Species]] <- ExpSumOrtho
  data.of <- data.o[,colnames(data.o) %in% colnames(SCTscale_l[[Species]])]
  DataOrtho_l[[Species]] <- data.of
}

########################################################################
###Extract Highly Expressed Genes
########################################################################
GeneList <- NULL
for (Species in Species_l) {
  if (Species == "Homo_sapiens") sp <- "Hs"
  if (Species == "Pan_troglodytes") sp <- "Pt"
  if (Species == "Macaca_mulatta") sp <- "Mm"
  if (Species == "Rousettus_aegyptiacus") sp <- "Ra"
  ExpSum <- ExpSumOrtho_l[[Species]]
  ExpSum.s <- sort(ExpSum,decreasing=T)[1:6000]
  GeneList <- union(GeneList,names(ExpSum.s))
}
saveRDS(GeneList,args[3])

########################################################################
###Concatenate Matrices
########################################################################
for (Species in Species_l) {
  DataOrtho <- DataOrtho_l[[Species]]
  DataOrtho.f <- DataOrtho[rownames(DataOrtho) %in% GeneList,]
  colnames(DataOrtho.f) <- paste(Species,colnames(DataOrtho.f),sep="__")
  DataOrtho_l[[Species]] <- DataOrtho.f
}
preData <- cbind(DataOrtho_l$Homo_sapiens,DataOrtho_l$Pan_troglodytes,
              DataOrtho_l$Macaca_mulatta,DataOrtho_l$Rousettus_aegyptiacus)
Data <- t(preData)
rownames(Data) <- colnames(preData)

########################################################################
###Calculate Mean values
########################################################################
out_l <- list()
mt_l <- list()
for (Species in Species_l) {
  mt <- readRDS(paste(args[1],Species,"/",Species,"_metadata.rds",sep=""))
  mt$ID <- paste(Species,rownames(mt),sep="__")
  mt$Species <- Species
  mt_l[[Species]] <- mt
  out_l[[Species]] <- list()
  for (Stim in Stim_l) {
    mt.s <- mt[mt$Stim == Stim,]
    data_l.s <- list()
    for (Ca in Cell_l) {
      mt.sc <- mt.s[mt.s$CoreClusterLabel == Ca,]
      Data.sc <- Data[rownames(Data) %in% mt.sc$ID,]
      if (nrow(mt.sc) == 0) data_l.s[[Ca]] <- NA
      if (nrow(mt.sc) == 1) data_l.s[[Ca]] <- as.numeric(Data.sc)
      if (nrow(mt.sc) >= 2) data_l.s[[Ca]] <- apply(Data.sc,2,mean)
    }
    data.sps <- as.data.frame(data_l.s)
    out_l[[Species]][[Stim]] <- data.sps
  }
}
saveRDS(out_l,args[4])



