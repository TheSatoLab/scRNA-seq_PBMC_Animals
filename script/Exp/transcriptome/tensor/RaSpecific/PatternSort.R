#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)

data <- readRDS(args[1])
mt <- readRDS(args[2])
mt.f <- mt[mt$Species == "Homo_sapiens",]
data.sf <- data[,colnames(data) %in% mt.f$ID]
sum <- apply(data.sf,1,mean)
sum.df <- data.frame(gene = names(sum),sum = sum)
Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("HSV1","SeV","LPS")
Cell_l <- c("B","NaiveT","KillerTNK","Mono")

ReduceClass <- function(x) {
  out <- switch(x,
    "ALLhigh" = "ALLhigh",
    "ALLlow"  = "ALLlow",
    "Others")
  return(out)
}

data1 <- readRDS(args[3])
data2 <- readRDS(args[4])
data3 <- readRDS(args[5])
data1$RedCommon <- sapply(as.character(data1$Class10),ReduceClass)
data2$RedRa <- sapply(as.character(data2$Class10),ReduceClass)
data3$RedMm <- sapply(as.character(data3$Class10),ReduceClass)
data1$Common <- data1$Class10
data2$Ra <- data2$Class10
data3$Mm <- data3$Class10
#data1a <- filter(data1,Class10 == "ALLhigh")
#data2a <- filter(data2,Class10 == "ALLhigh")
#data3a <- filter(data3,Class10 == "ALLhigh")
#genes <- unique(c(rownames(data1a),rownames(data2a),rownames(data3a)))

#data1f <- data1[rownames(data1) %in% genes, c("gene","Common","RedCommon")]
#data2f <- data2[rownames(data2) %in% genes, c("gene","Ra","RedRa")]
#data3f <- data3[rownames(data3) %in% genes, c("gene","Mm","RedMm")]
data1f <- data1[, c("gene","Common","RedCommon")]
data2f <- data2[, c("gene","Ra","RedRa")]
data3f <- data3[, c("gene","Mm","RedMm")]
data.m <- merge(data1f,data2f,by="gene")
data.m <- merge(data.m,data3f,by="gene")
data.m <- merge(data.m,sum.df,by="gene")

RedClass10_l <- c("ALLhigh","ALLlow","Others")
data.m$RedCommon <- factor(data.m$RedCommon,level = RedClass10_l)
data.m$RedRa <- factor(data.m$RedRa,level = RedClass10_l)
data.m$RedMm <- factor(data.m$RedMm,level = RedClass10_l)
data.m <- data.m[order(data.m$RedCommon,data.m$RedRa,data.m$RedMm,data.m$sum),]
rownames(data.m) <- data.m$gene
write.table(data.m,args[6],quote=F,sep="\t",row.names=F)


