#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
library(future)
library(amap)
library(ComplexHeatmap)
library(circlize)
plan("multicore",workers=24)
options(future.globals.maxSize = 16000000000)
set.seed(1)

Seurat <- readRDS(args[1])
dims <- 1:30
#########################################################
p1 <- DimPlot(Seurat,group.by="MergeCluster",label=T)
pdf(args[2],height=10,width=10)
print(p1)
dev.off()

##########################################################
embeddings <- Embeddings(Seurat,reduction="pca")[,dims]
calc_meanPC <- function(x) {
  cells <- WhichCells(object = Seurat, idents = x)
  if (length(cells) == 1) cells <- c(cells, cells)
  temp <- colMeans(embeddings[cells, ])
}
data.dims <- lapply(levels(Seurat),calc_meanPC)
data.dims <- do.call(what = 'cbind', args = data.dims)
colnames(data.dims) <- levels(Seurat)
data.dist <- dist(t(data.dims))

dist_mat <- as.matrix(data.dist)
diag(dist_mat) <- NA
c <- hclust(data.dist, method="ward.D2")

pdf(args[3],height=7,width=7)
ht1 = Heatmap(as.matrix(dist_mat),
              name = "Dist",
              cluster_columns=as.dendrogram(c),
              cluster_rows=as.dendrogram(c),
              col = colorRamp2(c(10,40,70),c("red","yellow","white"))
              )
draw(ht1)
dev.off()


