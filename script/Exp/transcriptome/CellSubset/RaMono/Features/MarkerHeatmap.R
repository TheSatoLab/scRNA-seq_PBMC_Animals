#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)
library(Seurat)
library(ComplexHeatmap)
library(circlize)

Seurat <- readRDS(args[1])
Mock <- subset(Seurat,subset= Stim == "Mock")
Stim <- subset(Seurat,subset= Stim != "Mock")
Mean.Mock <- t(apply(Mock@assays$SCT@data,1,tapply,Mock$MonoClusterID,mean))
Mean.Stim <- t(apply(Stim@assays$SCT@data,1,tapply,Stim$MonoClusterID,mean))
colnames(Mean.Mock) <- paste("Mock",1:7,sep="")
colnames(Mean.Stim) <- paste("Stim",1:7,sep="")
Mean <- cbind(Mean.Mock,Mean.Stim)
up <- read.table(args[2],header=T)
down <- read.table(args[3],header=T)
DEG <- rbind(up,down)
DEG <- DEG[,c("gene","Cluster","avg_log2FC")]
DEG5 <- DEG[DEG$Cluster == "5",]
DEG7 <- DEG[DEG$Cluster == "7",]

data5 <- merge(DEG5,Mean,by.x="gene",by.y=0)
data7 <- merge(DEG7,Mean,by.x="gene",by.y=0)
data5 <- data5[order(data5$avg_log2FC,decreasing=T),]
data7 <- data7[order(data7$avg_log2FC,decreasing=T),]
rownames(data5) <- data5$gene
rownames(data7) <- data7$gene
data5 <- select(data5,-gene,-Cluster,-avg_log2FC)
data7 <- select(data7,-gene,-Cluster,-avg_log2FC)
data5 <- t(apply(data5,1,scale))
data7 <- t(apply(data7,1,scale))

Stim_l <- c("Mock" = "pink","Stim" = "green")
Cluster_l = c("1" = "pink","2" = "skyblue","3" = "green","4" = "orange",
              "5" = "red","6" = "blue","7" = "gray")

ha1 <- HeatmapAnnotation(
  Stim = c(rep("Mock",7),rep("Stim",7)),
  Cluster = c(1:7,1:7), 
  col= list(Stim = Stim_l,Cluster = Cluster_l))
ht5 <- Heatmap(as.matrix(data5),#right_annotation = ra,
               top_annotation=ha1,
               show_row_names=T,show_column_names=F,cluster_columns=F,cluster_rows=F,
               name = "C5",row_names_gp = gpar(fontsize=6),
               col = colorRamp2(c(-1,0,1),c("blue","white","red")))
pdf(args[4],height=8,width=5)
draw(ht5)
dev.off()

ht7 <- Heatmap(as.matrix(data7),#right_annotation = ra,
               top_annotation=ha1,
               show_row_names=T,show_column_names=F,cluster_columns=F,cluster_rows=F,
               name = "C7",row_names_gp = gpar(fontsize=6),
               col = colorRamp2(c(-1,0,1),c("blue","white","red")))
pdf(args[5],height=8,width=5)
draw(ht7)
dev.off()

















