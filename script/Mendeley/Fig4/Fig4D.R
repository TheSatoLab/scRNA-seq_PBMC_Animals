#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(tidyverse)

Seurat <- readRDS(args[1])
mt <- Seurat@meta.data
mt.f <- mt %>%
  select(Stim,MonoClusterID) %>%
  group_by(Stim,MonoClusterID) %>%
  summarise(n=n()) %>%
  as.data.frame()
Stim_l <- c("Mock","HSV1","SeV","LPS")
ff_l <- list()
for (Stim in Stim_l) {
  mt.ff <- mt.f[mt.f$Stim == Stim,]
  mt.ff$Freq <- mt.ff$n / sum(mt.ff$n)
  ff_l[[Stim]] <- mt.ff
}
CellRatio <- rbind(ff_l[[1]],ff_l[[2]],ff_l[[3]],ff_l[[4]])
write.table(CellRatio,args[2],sep="\t",quote=F,row.names=F)


