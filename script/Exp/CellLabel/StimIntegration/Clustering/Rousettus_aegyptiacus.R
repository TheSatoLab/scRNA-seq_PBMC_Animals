#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
library(future)
library(amap)
library(ComplexHeatmap)
library(circlize)
plan("multicore",workers=8)
options(future.globals.maxSize = 16000000000)
set.seed(1)

Seurat <- readRDS(args[1])
integrated <- readRDS(args[2])
Seurat@assays$integrated <- integrated
Seurat@active.assay <- "integrated"
mt <- readRDS(args[3])
Seurat@meta.data <- mt
dims <- 1:50
Seurat <- RunUMAP(Seurat,reduction = "pca",dims = dims,n.neighbors =40)
Seurat <- FindNeighbors(Seurat,reduction = "pca", dim = dims,k.param = 20)
Seurat <- FindClusters(Seurat, resolution =1.2)
new.cluster.ids <- as.character(1:length(levels(Seurat$seurat_clusters)))
names(new.cluster.ids) <- levels(Seurat)
Seurat <- RenameIdents(Seurat,new.cluster.ids)
mt.p <- Seurat@meta.data
mt.p <- mt.p[,colnames(mt.p) %in% colnames(mt)]
Seurat@meta.data <- mt.p
Seurat$BasicClusterID <- Seurat@active.ident

#########################################################
dummy <- Seurat@assays$dummy
Seurat@assays$dummy <- NULL

p1_1 <- plot_grid(DimPlot(Seurat,group.by="BasicClusterID",label=T),NULL,ncol=2,rel_widths=c(1,0.3))
Seurat.Mock <- subset(Seurat,subset=Stim=="Mock")
Seurat.Mock$predicted.id  <- factor(Seurat.Mock$predicted.id,level=unique(Seurat.Mock$predicted.id))
p1_2 <- DimPlot(Seurat.Mock,group.by="predicted.id",label=T)
p1 <- plot_grid(p1_1,p1_2,ncol=2,rel_widths=c(1.2,1))

pdf(args[4],height=5,width=14)
print(p1)
dev.off()

Seurat@assays$integrated <- NULL
Seurat@assays$dummy <- dummy
Seurat@active.assay <- "dummy"
saveRDS(Seurat,args[1])
saveRDS(Seurat@meta.data,args[3])

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

pdf(args[5],height=5,width=5)
ht1 = Heatmap(as.matrix(dist_mat),
              name = "Dist",
              cluster_columns=as.dendrogram(c),
              cluster_rows=as.dendrogram(c),
              col = colorRamp2(c(10,40,70),c("red","yellow","white"))
              )
draw(ht1)
dev.off()


