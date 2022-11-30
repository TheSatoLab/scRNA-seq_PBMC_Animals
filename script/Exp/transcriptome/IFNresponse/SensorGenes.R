#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)
library(Seurat)

SCT <- readRDS(args[1])
data <- SCT@data
mt <- readRDS(args[2])
geneset <- read.table(args[3], header=T, check.names=F)
if (args[4] == "Homo_sapiens") sp <- "Hs"
if (args[4] == "Pan_troglodytes") sp <- "Pt"
if (args[4] == "Macaca_mulatta") sp <- "Mm"
if (args[4] == "Rousettus_aegyptiacus") sp <- "Ra"
data.f <- data[rownames(data) %in% geneset[,sp],]
data.pmm <- merge(geneset,data.f,by.x=sp,by.y=0)
rownames(data.pmm) <- data.pmm$Hs
data.m <- select(data.pmm,one_of(as.character(rownames(mt))))
mt.m <- cbind(mt,t(data.m))

for (gene in geneset$Hs) {
  if (!(gene %in% colnames(mt.m))) mt.m[,gene] <- NA
}

saveRDS(mt.m,args[5])


