#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(ComplexHeatmap)
library(circlize)
library(amap)
library(tidyverse)

data <- readRDS(args[1])
U3 <- t(data$A[[3]])
U3 <- U3/max(U3)
ht3 <- Heatmap(U3,cluster_columns=F,cluster_rows=F,
               name = "CellType",
               col = colorRamp2(c(-1,0,1),c("blue","white","red")))
               
pdf(args[2],height=3,width=3)
draw(ht3)
dev.off()

