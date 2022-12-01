#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(tidyverse)
library(ggplot2)

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

p <- ggplot(CellRatio,aes(x=Stim, y=Freq, fill=MonoClusterID))
p <- p + geom_bar(stat = "identity")
p <- p + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

pdf(args[2],height=4, width=4)
print(p)
dev.off()


