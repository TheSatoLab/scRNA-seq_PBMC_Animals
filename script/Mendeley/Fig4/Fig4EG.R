#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)
library(Seurat)

Seurat <- readRDS(args[1])
Stim <- subset(Seurat,subset= Stim != "Mock")
Mean <- t(apply(Stim@assays$SCT@data,1,tapply,Stim$MonoClusterID,mean))
colnames(Mean) <- paste("Stim",1:7,sep="")

up <- read.table(args[2],header=T)
down <- read.table(args[3],header=T)
DEG <- rbind(up,down)
DEG <- DEG[DEG$Cluster == args[4],]

data <- merge(DEG,Mean,by.x="gene",by.y=0)
data <- data[order(data$avg_log2FC,decreasing=T),]
data <- select(data,-Cluster)
data.f <- as.data.frame(t(apply(data[,7:13],1,scale)))
colnames(data.f) <- paste("RaC",1:7,sep="")
out <- cbind(data[,1:6],data.f)
write.table(out,args[5],sep="\t",quote=F,row.names=F)





