#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)

data <- readRDS(args[1])
mt <- readRDS(args[2])
rownames(mt) <- mt$ID
mt <- mt[,c("ID","Species","Stim","CellType")]

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("HSV1","SeV","LPS")
Cell_l <- c("B","NaiveT","KillerTNK","Mono")
data.m <- read.table(args[3],header=T,sep="\t")
rownames(data.m) <- data.m$gene
data.m <- data.m[,c("Ra","RedCommon")]
data.m <- data.m[data.m$Ra == "ALLhigh",]
for (gene in rownames(data.m)) {
  if (data.m[gene,2] == "Others") data.m[gene,2] <- "OtherGC"
}

data.f <- as.data.frame(data[rownames(data) %in% rownames(data.m),])
data.f$gene <- factor(rownames(data.f),level=rownames(data.m))
data.f <- data.f[order(data.f$gene),]
data.f <- data.f[,colnames(data.f) != "gene"]

out <- rbind(t(mt),data.f)
ra <- as.data.frame(c("GeneCategory","GeneCategory","GeneCategory","GeneCategory",data.m[,"RedCommon"]))
colnames(ra) <- "GeneCategory"
out <- cbind(ra,out)
write.table(out,args[4],quote=F,sep="\t",col.names=F)




