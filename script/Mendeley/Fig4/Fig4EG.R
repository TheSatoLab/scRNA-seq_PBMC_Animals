#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)
library(Seurat)
library(ComplexHeatmap)
library(circlize)

Seurat <- readRDS(args[1])
Stim <- subset(Seurat,subset= Stim != "Mock")
Mean.Stim <- t(apply(Stim@assays$SCT@data,1,tapply,Stim$MonoClusterID,mean))
colnames(Mean.Stim) <- paste("Stim",1:7,sep="")
Mean <- Mean.Stim
up <- read.table(args[2],header=T)
down <- read.table(args[3],header=T)
DEG <- rbind(up,down)
DEG <- DEG[,c("gene","Cluster","avg_log2FC")]
DEG <- DEG[DEG$Cluster == args[4],]

data <- merge(DEG,Mean,by.x="gene",by.y=0)
data <- data[order(data$avg_log2FC,decreasing=T),]
rownames(data) <- data$gene
data <- select(data,-gene,-Cluster,-avg_log2FC)
data <- t(apply(data,1,scale))

Cluster_l = c("1" = "pink","2" = "skyblue","3" = "green","4" = "orange",
              "5" = "red","6" = "blue","7" = "gray")

ha1 <- HeatmapAnnotation(
  Cluster = 1:7, 
  col= list(Cluster = Cluster_l))
ht <- Heatmap(as.matrix(data),#right_annotation = ra,
               top_annotation=ha1,
               show_row_names=T,show_column_names=F,cluster_columns=F,cluster_rows=F,
               name = "C5",row_names_gp = gpar(fontsize=6),
               col = colorRamp2(c(-2,0,2),c("blue","white","red")))
pdf(args[5],height=8,width=5)
draw(ht)
dev.off()








