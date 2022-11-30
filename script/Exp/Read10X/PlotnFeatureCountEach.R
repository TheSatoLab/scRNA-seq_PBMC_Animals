#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
options(future.globals.maxSize = 16000000000)

preSeurat <- readRDS(args[1])
pdf(args[2],height=5,width=25)
hist(preSeurat$nFeature_RNA,breaks=200,xlim=c(0,8000))
dev.off()
pdf(args[3],height=5,width=25)
hist(preSeurat$nCount_RNA,breaks=200,xlim=c(0,50000))
dev.off()

