#!/usr/bin/env R

args <- commandArgs(T)
library(ComplexHeatmap)
library(amap)
library(circlize)
library(tidyverse)
library(RColorBrewer)

data <- readRDS(args[1])
mt <- read.table(args[2],header=T,sep="\t")
mt$Species <- factor(mt$Species,level=c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus"))
mt$Stim <- factor(mt$Stim,level=c("HSV1","SeV","LPS"))
mt$SixCellType <- factor(mt$CellType,level=c("B","NaiveT","KillerTNK","Mono"))

pca_res <- prcomp(t(data))
pca <- pca_res$x
pca <- pca[,1:30]

d1 <- Dist(pca, method="pearson",nbproc=24)
c1 <- hclust(d1, method="ward.D2")

cols_Species <- brewer.pal(4, "Dark2")
cols_Stim <- brewer.pal(6, "Set2")
ha <- HeatmapAnnotation(
  Species = mt$Species,
  Stim = mt$Stim,
  SixCellType = mt$SixCellType,
  col= list(
  Species = c("Homo_sapiens" = cols_Species[1],"Pan_troglodytes" = cols_Species[2],"Macaca_mulatta" = cols_Species[3],"Rousettus_aegyptiacus" = cols_Species[4]),
  Stim = c("HSV1" = cols_Stim[3],"SeV" = cols_Stim[4],"LPS" = cols_Stim[5]),
  SixCellType = c("B" = "pink","NaiveT" = "skyblue","KillerTNK" = "greenyellow","Mono" = "orange")

  )
)

dist_pca <- as.matrix(d1)
diag(dist_pca) <- NA
hts <- Heatmap(dist_pca,top_annotation = ha,
               cluster_columns=as.dendrogram(c1),
               cluster_rows=as.dendrogram(c1),
               show_row_names=F,
               show_column_names=F,
               column_dend_height = unit(4, "cm"),
               name = "dist",width=unit(10,"cm"),
               col = colorRamp2(c(0,0.5,1.5),c("black","red","white")))

pdf(args[3],height=7,width=7)
draw(hts)
dev.off()

