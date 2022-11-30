#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(Azimuth)
library(cowplot)
source("Exp/Azimuth/azimuth_base.R")
reference <- readRDS(args[1])
Idents(reference$map) <- "celltype.l3"
Idents(reference$plot) <- "celltype.l3"

if (args[2] == "Homo_sapiens") {
  query <- readRDS(args[3])
} else {
  query <- readRDS(args[4])
}
query <- Azimuth(query,reference,"celltype.l3")
query@active.assay <- "prediction.score.celltype.l3"
query@assays$RNA <- NULL
query@assays$refAssay <- NULL
query@assays$impADT <- NULL
query@reductions$integrated_dr <- NULL
saveRDS(query,args[5])
saveRDS(query@meta.data,args[6])


### VISUALIZATIONS
p1_1 <- DimPlot(object = reference$plot, reduction = "refUMAP", group.by = "celltype.l3", label = TRUE) + NoLegend()
p1_2 <- DimPlot(object = query, reduction = "proj.umap", group.by = "predicted.celltype.l3", label = TRUE) + NoLegend()
p1 <- plot_grid(p1_1,p1_2, ncol=2,rel_widths =c(1,1))

p2_1 <- FeaturePlot(object = query, features = "predicted.celltype.l3.score", reduction = "proj.umap")
p2_2 <- VlnPlot(object = query, features = "predicted.celltype.l3.score", group.by = "predicted.celltype.l3") + NoLegend()
p2 <- plot_grid(p2_1,p2_2, ncol=2,rel_widths =c(1,1))

p3_1 <- FeaturePlot(object = query, features = "mapping.score", reduction = "proj.umap")
p3_2 <- VlnPlot(object = query, features = "mapping.score", group.by = "predicted.celltype.l3") + NoLegend()
p3 <- plot_grid(p3_1,p3_2, ncol=2,rel_widths =c(1,1))

p <- plot_grid(p1,p2,p3,ncol=1,rel_heights=c(1,1,1))

pdf(args[7],height=24,width=16)
print(p)
dev.off()

