#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(ComplexHeatmap)
library(circlize)
library(amap)
library(tidyverse)

data <- readRDS(args[1])
U1 <- t(data$A[[1]])
U2 <- t(data$A[[2]])
U3 <- t(data$A[[3]])
U4 <- t(data$A[[4]])

ht1 <- Heatmap(U1,cluster_columns=F,cluster_rows=F,
               name = "Species",
               col = colorRamp2(c(-1,0,1),c("blue","white","red")))

ht2 <- Heatmap(U2,cluster_columns=F,cluster_rows=F,
               name = "Stim",
               col = colorRamp2(c(-1,0,1),c("blue","white","red")))
U3 <- U3/max(U3)
ht3 <- Heatmap(U3,cluster_columns=F,cluster_rows=F,
               name = "CellType",
               col = colorRamp2(c(-1,0,1),c("blue","white","red")))
               
pdf(args[2],height=5,width=5)
draw(ht1)
dev.off()

pdf(args[3],height=5,width=5)
draw(ht2)
dev.off()

pdf(args[4],height=5,width=5)
draw(ht3)
dev.off()

if (1) {
#d1 <- Dist(t(U4), method="euclid",nbproc=24)
#c1 <- hclust(d1, method="ward.D2")

ht4 <- Heatmap(U4,cluster_columns=F,cluster_rows=F,show_column_names=F,
               name = "Genes",
               col = colorRamp2(c(-0.02,0,0.02),c("blue","white","red")))
#cluster_columns=as.dendrogram(c1)

pdf(args[5],height=10,width=10)
draw(ht4)
dev.off()
}


