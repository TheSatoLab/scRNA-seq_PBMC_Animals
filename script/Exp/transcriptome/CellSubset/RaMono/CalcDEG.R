#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(future)
library(tidyverse)
plan("multicore",workers=8)
options(future.globals.maxSize = 16000000000)
set.seed(1)

Seurat <- readRDS(args[1])
Seurat@active.assay <- "SCT"
Seurat <- subset(Seurat,subset=Stim!="Mock")
DEG5 <- FindMarkers(Seurat,"5",min.pct = 0,logfc.threshold = 0)
DEG7 <- FindMarkers(Seurat,"7",min.pct = 0,logfc.threshold = 0)
DEG5 <- DEG5 %>% mutate(gene = rownames(DEG5)) %>% mutate(Cluster = "5")
DEG7 <- DEG7 %>% mutate(gene = rownames(DEG7)) %>% mutate(Cluster = "7")
out_l <- list(C5 = DEG5,C7 = DEG7)
saveRDS(out_l,args[2])
DEG5.f <- DEG5 %>% filter(p_val_adj <= 0.05) %>% filter(avg_log2FC >= 1) %>% filter(pct.1 >= 0.2) %>% select(gene,Cluster,avg_log2FC,pct.1,pct.2,p_val,p_val_adj)
DEG7.f <- DEG7 %>% filter(p_val_adj <= 0.05) %>% filter(avg_log2FC >= 1) %>% filter(pct.1 >= 0.2) %>% select(gene,Cluster,avg_log2FC,pct.1,pct.2,p_val,p_val_adj)
out <- rbind(DEG5.f,DEG7.f)
write.table(out,args[3],quote=F,sep="\t",row.names=F)

DEG5.fd <- DEG5 %>% filter(p_val_adj <= 0.05) %>% filter(avg_log2FC <= -1) %>% filter(pct.1 >= 0.2) %>% select(gene,Cluster,avg_log2FC,pct.1,pct.2,p_val,p_val_adj)
DEG7.fd <- DEG7 %>% filter(p_val_adj <= 0.05) %>% filter(avg_log2FC <= -1) %>% filter(pct.1 >= 0.2) %>% select(gene,Cluster,avg_log2FC,pct.1,pct.2,p_val,p_val_adj)
outd <- rbind(DEG5.fd,DEG7.fd)
write.table(outd,args[4],quote=F,sep="\t",row.names=F)


