#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)

Seurat <- readRDS(args[1])
mt <- readRDS(args[2])
dims <- 1:50
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

dist_mat <- as.data.frame(as.matrix(data.dist))
ID <- data.frame(ClusterID=1:nrow(dist_mat))
out <- cbind(ID,dist_mat)
write.table(out,args[3],sep="\t",quote=F,row.names=F)

