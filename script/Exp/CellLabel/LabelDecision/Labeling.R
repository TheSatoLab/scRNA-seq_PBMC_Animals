#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(tidyverse)

Seurat <- readRDS(args[1])
mt <- readRDS(args[2])
Seurat@meta.data <- mt
if (is.element("ClusterLabel",colnames(mt))) mt <- mt[,colnames(mt) != "ClusterLabel"]
mt <- mutate(mt,CB=rownames(mt))
Label <- read.table(args[3],header=T,sep="\t")
Label$BasicClusterID <- factor(Label$BasicClusterID,level=Label$BasicClusterID)
mt.m <- left_join(mt,Label,by="BasicClusterID")
rownames(mt.m) <- mt.m$CB
mt.m <- mt.m[,colnames(mt.m) != "CB"]
Seurat@meta.data <- mt.m
saveRDS(mt.m,args[2])

p1 <- DimPlot(Seurat,group.by="ClusterLabel",label=T)
pdf(args[4],height=6,width=8)
print(p1)
dev.off()


