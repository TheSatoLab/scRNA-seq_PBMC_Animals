#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(ComplexHeatmap)
library(circlize)
library(amap)
library(tidyverse)

data <- readRDS(args[1])
U1 <- t(data$A[[1]])

ht1 <- Heatmap(U1,cluster_columns=F,cluster_rows=F,
               name = "Species",
               col = colorRamp2(c(-1,0,1),c("blue","white","red")))
               
pdf(args[2],height=3,width=3)
draw(ht1)
dev.off()

