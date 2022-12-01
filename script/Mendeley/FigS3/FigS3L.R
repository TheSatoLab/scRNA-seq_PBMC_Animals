#!/usr/bin/env R

args <- commandArgs(T)
library(ggplot2)
library(ComplexHeatmap)
library(amap)
library(circlize)
library(tidyverse)
library(RColorBrewer)

data <- readRDS(args[1])
mt <- readRDS(args[2])

data.ao <- readRDS(args[3])
data.ao <- data.ao[data.ao$Class10 != "N_A",]
data.f <- data[rownames(data) %in% rownames(data.ao),]
data.f <- as.data.frame(data.f)
data.f$gene <- factor(rownames(data.f),level=data.ao$gene)
data.f <- data.f[order(data.f$gene),]
data.f <- data.f[,colnames(data.f) != "gene"]

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("HSV1","SeV","LPS")
Stim4_l <- c("Mock","HSV1","SeV","LPS")
Cell_l <- c("B","NaiveT","KillerTNK","Mono")

ra.df <- data.frame(Class10 = data.ao$Class10)
ra.df$Class10 <- factor(ra.df$Class10,level=levels(data.ao$Class10)[1:10])

ra <- rowAnnotation(df = ra.df,
                      col=list(Class10 = c("ALLhigh" = "pink","ALLlow" = "skyblue",
                                               "VIRUShigh" = "green","LPShigh" = "orange",
                                               "Bhigh" = "red","Blow" = "black","TNKhigh" = "white","TNKlow" = "blue",
                                               "MONOhigh" = "yellow","MONOlow" = "purple"
                                               )))

cols_Stim <- brewer.pal(6, "Set2")

haf <- HeatmapAnnotation(
  Species = mt$Species,
  Stim = mt$Stim,
  SixCellType = mt$SixCellType,
  col= list(
  Species = c("Homo_sapiens" = "pink","Pan_troglodytes" = "skyblue","Macaca_mulatta" = "green","Rousettus_aegyptiacus" = "orange"),
  Stim = c("HSV1" = cols_Stim[3],"SeV" = cols_Stim[4],"LPS" = cols_Stim[5]),
  SixCellType = c("B" = "pink","NaiveT" = "skyblue","KillerTNK" = "green","Mono" = "orange")
  )
)

htf <- Heatmap(as.matrix(data.f),top_annotation = haf,right_annotation = ra,
               cluster_columns=F,#as.dendrogram(c1),
               show_row_names=F,show_column_names=F,
               cluster_rows=F,#as.dendrogram(c2),
               row_dend_width = unit(2, "cm"),
               column_dend_height = unit(4, "cm"),
               name = "FC",
               use_raster=F,
               row_names_gp = gpar(fontsize=6),
               col = colorRamp2(c(-0.8,0,0.8),c("blue","white","red")))

pdf(args[4],height=3,width=9)
draw(htf)
dev.off()



