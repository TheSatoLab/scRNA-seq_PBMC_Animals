#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(tidyverse)

Species <- args[1]
if (Species == "Homo_sapiens")          sp <- "Hs"
if (Species == "Pan_troglodytes")       sp <- "Pt"
if (Species == "Macaca_mulatta")        sp <- "Mm"
if (Species == "Rousettus_aegyptiacus") sp <- "Ra"

data <- readRDS(args[2])
out <- data@counts
colnames(out) <- paste(sp,colnames(out),sep="_")
saveRDS(out,args[3])

