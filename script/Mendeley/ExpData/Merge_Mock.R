#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(tidyverse)

data <- readRDS(args[1])
out <- data@assays$integrated@data
name.df <- as.data.frame(strsplit(colnames(out),"_"))
colnames(out) <- paste(as.character(name.df[1,]),"Mock",as.character(name.df[2,]),sep="_")
saveRDS(out,args[2])


