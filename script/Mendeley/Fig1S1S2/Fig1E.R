#!/usr/bin/env R

args <- commandArgs(T)
library(amap)
library(tidyverse)

data <- readRDS(args[1])
mt <- read.table(args[2],header=T,sep="\t")
mt$Species <- factor(mt$Species,level=c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus"))
mt$Stim <- factor(mt$Stim,level=c("HSV1","SeV","LPS"))
mt$SixCellType <- factor(mt$CellType,level=c("B","NaiveT","KillerTNK","Mono"))

pca_res <- prcomp(t(data))
pca <- pca_res$x
pca <- pca[,1:30]

d1 <- Dist(pca, method="pearson",nbproc=24)
c1 <- hclust(d1, method="ward.D2")
dist_pca <- as.matrix(d1)
colnames(dist_pca) <- paste("Dist",colnames(dist_pca),sep="__")
#diag(dist_pca) <- NA
mt <- mt[,c("ID","Species","Stim","CellType")]
mt <- cbind(mt,dist_pca,pca)
out <- rbind(as.data.frame(t(mt)),data)
write.table(out,args[3],sep="\t",quote=F,col.names=F)

