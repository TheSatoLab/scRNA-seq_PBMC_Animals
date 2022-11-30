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

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("HSV1","SeV","LPS")
Cell_l <- c("B","NaiveT","KillerTNK","Mono")
data.m <- read.table(args[3],header=T,sep="\t")
rownames(data.m) <- data.m$gene
data.m <- data.m[,c("Ra","RedCommon")]
data.m <- data.m[data.m$Ra == "ALLhigh",]

data.f <- as.data.frame(data[rownames(data) %in% rownames(data.m),])
data.f$gene <- factor(rownames(data.f),level=rownames(data.m))
data.f <- data.f[order(data.f$gene),]
data.f <- data.f[,colnames(data.f) != "gene"]

Col_l <- c("ALLhigh" = "pink","ALLlow" = "skyblue",
         "VIRUShigh" = "green","LPShigh" = "orange",
         "Bhigh" = "red","Blow" = "black","TNKhigh" = "white","TNKlow" = "blue",
         "MONOhigh" = "yellow","MONOlow" = "purple","Others" = "aquamarine","N_A" = "gray50")
RedCol_l <- c("ALLhigh" = "pink","ALLlow" = "skyblue","Others" = "gray")

ra <- rowAnnotation(df = data.m[,"RedCommon"],
                    col=list(RedCommmon = RedCol_l))

cols_Species <- brewer.pal(4, "Dark2")
cols_Stim <- brewer.pal(6, "Set2")

ha <- HeatmapAnnotation(
  Species = mt$Species,
  Stim = mt$Stim,
  CellType = mt$SixCellType,
  col= list(
  Species = c("Homo_sapiens" = cols_Species[1],"Pan_troglodytes" = cols_Species[2],"Macaca_mulatta" = cols_Species[3],"Rousettus_aegyptiacus" = cols_Species[4]),
  Stim = c("HSV1" = cols_Stim[3],"SeV" = cols_Stim[4],"LPS" = cols_Stim[5]),
  SixCellType = c("B" = "pink","NaiveT" = "skyblue","KillerTNK" = "greenyellow","Mono" = "orange")
  )
)


hts <- Heatmap(as.matrix(data.f),top_annotation = ha,right_annotation = ra,
               cluster_columns=F,#as.dendrogram(c1),
               show_row_names=T,
               show_column_names=F,
               cluster_rows=F,#as.dendrogram(c2),
               name = "FC",
               row_names_gp = gpar(fontsize=4),
               col = colorRamp2(c(-10,-5,0,5,10),c("black","blue","white","red","black")))

pdf(args[4],height=3,width=8)
draw(hts)
dev.off()



