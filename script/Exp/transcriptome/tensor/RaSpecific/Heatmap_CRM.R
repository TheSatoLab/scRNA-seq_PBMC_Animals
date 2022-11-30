#!/usr/bin/env R

args <- commandArgs(T)
library(ggplot2)
library(ComplexHeatmap)
library(amap)
library(circlize)
library(tidyverse)

data <- readRDS(args[1])
mt <- readRDS(args[2])

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("HSV1","SeV","LPS")
Cell_l <- c("B","NaiveT","KillerTNK","Mono")
data.m <- read.table(args[3],header=T,sep="\t")
rownames(data.m) <- data.m$gene
data.m <- data.m[,c("RedCommon","RedRa","RedMm")]

data1a <- filter(data.m,RedCommon == "ALLhigh")
data2a <- filter(data.m,RedRa == "ALLhigh")
data3a <- filter(data.m,RedMm == "ALLhigh")
genes <- unique(c(rownames(data1a),rownames(data2a),rownames(data3a)))
data.m <- data.m[rownames(data.m) %in% genes,]

data.f <- as.data.frame(data[rownames(data) %in% rownames(data.m),])
data.f$gene <- factor(rownames(data.f),level=rownames(data.m))
data.f <- data.f[order(data.f$gene),]
data.f <- data.f[,colnames(data.f) != "gene"]

Col_l <- c("ALLhigh" = "pink","ALLlow" = "skyblue","Others" = "gray")
ra <- rowAnnotation(df = data.m,
                    col=list(RedCommmon = Col_l,RedRa = Col_l,RedMm = Col_l))

ha <- HeatmapAnnotation(
  Species = mt$Species,
  Stim = mt$Stim,
  CellType = mt$SixCellType,
  col= list(
  Species = c("Homo_sapiens" = "pink","Pan_troglodytes" = "skyblue","Macaca_mulatta" = "green","Rousettus_aegyptiacus" = "orange"),
  Stim = c("HSV1" = "skyblue","SeV" = "green","LPS" = "orange"),
  SixCellType = c("B" = "pink","NaiveT" = "skyblue","KillerTNK" = "green","Mono" = "orange")
  )
)


hts <- Heatmap(as.matrix(data.f),top_annotation = ha,right_annotation = ra,
               cluster_columns=F,#as.dendrogram(c1),
               show_row_names=F,
               cluster_rows=F,#as.dendrogram(c2),
               name = "FC",
               row_names_gp = gpar(fontsize=6),
               col = colorRamp2(c(-2,0,2),c("blue","white","red")))

pdf(args[4],height=6,width=6)
draw(hts)
dev.off()



