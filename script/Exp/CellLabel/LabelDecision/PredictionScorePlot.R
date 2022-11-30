#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(tidyverse)
library(ComplexHeatmap)
library(circlize)

query <- readRDS(args[1])
data <- query@assays$prediction.score.id.coarse@data
colnames(data) <- paste("Mock_",colnames(data),sep="")
mt <- readRDS(args[2])
mt <- mt[mt$Stim == "Mock",]

RowCluster_level <- c(
  "B_Naive","B_nonNaive","Plasmablast",
  "CD4T_Naive","CD4TCM","CD4_CTL","Treg","CD4T_nonNaive",
  "CD8T_Naive","CD8T_nonNaive",
  "MAIT","gdT","dnT","NK",
  "Mono1","Mono2","cDC","pDC","Others"
  )
ColCluster_level <- c(
  "B-Naive","B-nonNaive","Plasmablast",
  "CD4T-Naive","CD4-Proliferating","CD4TCM","CD4-CTL","Treg",
  "CD8T-Naive","CD8T-nonNaive",
  "MAIT","gdT","dnT","NK",
  "cMono","ncMono","cDC","pDC","other"
  )

Cluster_level_fil_row <- RowCluster_level[RowCluster_level %in% unique(mt$ClusterLabel)]
mt$ClusterLabel <- factor(mt$ClusterLabel,level = Cluster_level_fil_row)

data <- select(as.data.frame(data),one_of(as.character(rownames(mt))))
data.mean <- as.data.frame(apply(data,1,tapply,mt$ClusterLabel,mean))
data.mean <- select(data.mean,one_of(as.character(ColCluster_level)))

pdf(args[3],height=5,width=6)
ht1 = Heatmap(as.matrix(data.mean),
              name = "mean\nprediction score",
              cluster_columns=F,
              cluster_rows=F,
              col = colorRamp2(c(0,1),c("white","red"))
              )
draw(ht1)
dev.off()





