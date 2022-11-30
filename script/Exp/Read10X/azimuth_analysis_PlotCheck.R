#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
#library(Azimuth)
reference <- readRDS(args[1])
query <- readRDS(args[2])

# VISUALIZATIONS

# DimPlot of the reference
p1_1 <- DimPlot(object = reference$plot, reduction = "refUMAP", group.by = "celltype.l2", label = TRUE) + NoLegend()
# DimPlot of the query, colored by predicted cell type
p1_2 <- DimPlot(object = query, reduction = "proj.umap", group.by = "predicted.celltype.l2", label = TRUE) + NoLegend()
p1 <- plot_grid(p1_1,p1_2, ncol=2,rel_widths =c(1,1))

# Plot the score for the predicted cell type of the query
p2_1 <- FeaturePlot(object = query, features = "predicted.celltype.l2.score", reduction = "proj.umap")
p2_2 <- VlnPlot(object = query, features = "predicted.celltype.l2.score", group.by = "predicted.celltype.l2") + NoLegend()
p2 <- plot_grid(p2_1,p2_2, ncol=2,rel_widths =c(1,1))

# Plot the mapping score
p3_1 <- FeaturePlot(object = query, features = "mapping.score", reduction = "proj.umap")
p3_2 <- VlnPlot(object = query, features = "mapping.score", group.by = "predicted.celltype.l2") + NoLegend()
p3 <- plot_grid(p3_1,p3_2, ncol=2,rel_widths =c(1,1))


p <- plot_grid(p1,p2,p3,ncol=1,rel_heights=c(1,1,1))

pdf(args[3],height=15,width=10)
print(p)
dev.off()

