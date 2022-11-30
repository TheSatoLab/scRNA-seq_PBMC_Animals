#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(ComplexHeatmap)
library(circlize)
library(amap)
library(tidyverse)

data <- readRDS(args[1])

U2 <- t(data$A[[2]])

ht2 <- Heatmap(U2,cluster_columns=F,cluster_rows=F,
               name = "Stim",
               col = colorRamp2(c(-1,0,1),c("blue","white","red")))
               
pdf(args[2],height=3,width=3)
draw(ht2)
dev.off()

