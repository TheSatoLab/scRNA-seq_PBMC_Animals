#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
library(tidyverse)

combined <- readRDS(args[1])
mt.c <- combined@meta.data
mt.c <- mutate(mt.c,CID = rownames(mt.c))

mt_l <- list()
for (i in 1:4) {
  mt <- readRDS(args[i+1])
  sp <- c("Hs","Pt","Mm","Ra")[i]
  mt.t <- mutate(mt,pCID = rownames(mt))
  mt.t <- mutate(mt.t,CB = gsub("Mock_","",mt.t$pCID))
  mt.t <- mutate(mt.t,CID= paste(sp,"_",mt.t$CB,sep=""))
  mt.t <- select(mt.t,CID,BasicClusterID)
  mt.m <- merge(mt.c,mt.t,by="CID")
  mt_l[[sp]] <- mt.m
}
mt.cl <- rbind(mt_l[["Hs"]],mt_l[["Pt"]],mt_l[["Mm"]],mt_l[["Ra"]])
combined$ClusterLabel <- mt.cl$BasicClusterID

combined.Hs <- subset(combined,subset=Species=="Hs")
combined.Pt <- subset(combined,subset=Species=="Pt")
combined.Mm <- subset(combined,subset=Species=="Mm")
combined.Ra <- subset(combined,subset=Species=="Ra")

p1 <- DimPlot(combined.Hs,group.by="ClusterLabel",label=T) + NoLegend() + ggtitle("Hs")
p2 <- DimPlot(combined.Pt,group.by="ClusterLabel",label=T) + NoLegend() + ggtitle("Pt")
p3 <- DimPlot(combined.Mm,group.by="ClusterLabel",label=T) + NoLegend() + ggtitle("Mm")
p4 <- DimPlot(combined.Ra,group.by="ClusterLabel",label=T) + NoLegend() + ggtitle("Ra")
p <- plot_grid(p1,p2,p3,p4,ncol=2,rel_widths=c(1,1))

pdf(args[6],height=10,width=10)
print(p)
dev.off()

