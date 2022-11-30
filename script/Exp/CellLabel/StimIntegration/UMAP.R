#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
library(future)
plan("multicore",workers=8)
options(future.globals.maxSize = 16000000000)
set.seed(1)

Seurat <- readRDS(args[1])
RNA <- readRDS(args[2])
Seurat@assays$integrated <- RNA
Seurat@active.assay <- "integrated"
Seurat@assays$dummy <- NULL

Default <- readRDS(args[3])
Seurat.Mock <- subset(Seurat,subset=Stim=="Mock")
Seurat.Mock$predicted.id <- Default$predicted.celltype.l3
Seurat.Mock$predicted.id  <- factor(Seurat.Mock$predicted.id,level=unique(Seurat.Mock$predicted.id))


p1_1 <- plot_grid(DimPlot(Seurat,group.by="BasicClusterID",label=T),NULL,ncol=2,rel_widths=c(1,0.3))
p1_2 <- DimPlot(Seurat.Mock,group.by="predicted.id",label=T)
p1 <- plot_grid(p1_1,p1_2,ncol=2,rel_widths=c(1,1))

pdf(args[4],height=10,width=28)
print(p1)
dev.off()

