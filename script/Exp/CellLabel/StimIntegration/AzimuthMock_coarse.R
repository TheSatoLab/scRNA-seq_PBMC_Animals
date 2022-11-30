#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(Azimuth)
library(cowplot)
library(tidyverse)
source("Exp/Azimuth/azimuth_base.R")
reference <- readRDS(args[1])
ri <- read.table(args[2],sep="\t",header=T)
ri.f <- ri[,c("celltype.l3","id.coarse")]

mtm <- reference$map@meta.data
mtm <- mutate(mtm,CB = rownames(mtm))
mtm.m <- left_join(mtm,ri.f,by="celltype.l3")
reference$map$id.coarse <- mtm.m$id.coarse

mtp <- reference$plot@meta.data
mtp <- mutate(mtp,CB = rownames(mtp))
mtp.m <- left_join(mtp,ri.f,by="celltype.l3")
reference$plot$id.coarse <- mtp.m$id.coarse

Idents(reference$map) <- "id.coarse"
Idents(reference$plot) <- "id.coarse"

if (args[3] == "Homo_sapiens") {
  query <- readRDS(args[4])
} else {
  query <- readRDS(args[5])
}
query <- Azimuth(query,reference,"id.coarse")
query@active.assay <- "prediction.score.id.coarse"
query@assays$RNA <- NULL
query@assays$refAssay <- NULL
query@assays$impADT <- NULL
query@reductions$integrated_dr <- NULL
saveRDS(query,args[6])
saveRDS(query@meta.data,args[7])

# VISUALIZATIONS
p1_1 <- DimPlot(object = reference$plot, reduction = "refUMAP", group.by = "id.coarse", label = TRUE) + NoLegend()
p1_2 <- DimPlot(object = query, reduction = "proj.umap", group.by = "predicted.id.coarse", label = TRUE) + NoLegend()
p1 <- plot_grid(p1_1,p1_2, ncol=2,rel_widths =c(1,1))

p2_1 <- FeaturePlot(object = query, features = "predicted.id.coarse.score", reduction = "proj.umap")
p2_2 <- VlnPlot(object = query, features = "predicted.id.coarse.score", group.by = "predicted.id.coarse") + NoLegend()
p2 <- plot_grid(p2_1,p2_2, ncol=2,rel_widths =c(1,1))

p3_1 <- FeaturePlot(object = query, features = "mapping.score", reduction = "proj.umap")
p3_2 <- VlnPlot(object = query, features = "mapping.score", group.by = "predicted.id.coarse") + NoLegend()
p3 <- plot_grid(p3_1,p3_2, ncol=2,rel_widths =c(1,1))

p <- plot_grid(p1,p2,p3,ncol=1,rel_heights=c(1,1,1))

pdf(args[8],height=24,width=16)
print(p)
dev.off()



