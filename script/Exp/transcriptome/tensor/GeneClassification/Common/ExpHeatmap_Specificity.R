#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)
library(ComplexHeatmap)
library(circlize)
library(amap)

Class10_l <- c("ALLhigh","ALLlow","VIRUShigh","LPShigh","Bhigh","Blow","TNKhigh","TNKlow","MONOhigh","MONOlow","Others","N_A")
Class31_l <- c("ALLhigh","ALLlow",
               "VIRUShigh","LPSlow","VIRUSlow","LPShigh",
               "Bhigh","TNKMlow","Blow","TNKMhigh",
               "TNKhigh","BMlow","TNKlow","BMhigh",
               "Mhigh","BTNKlow","Mlow","BTNKhigh",
               "N_A")
data <- readRDS(args[1])
data.a <- read.table(args[4],header=T,sep="\t")
data.a$Class18 <- factor(data.a$Class18,level=Class31_l)
data.ao <- data.a[order(data.a$Class18),]
data.ao$Class10 <- factor(data.ao$Class10,level=Class10_l)

data.f <- as.data.frame(data[rownames(data) %in% data.ao$gene,])
data.f$gene <- factor(rownames(data.f),level=data.ao$gene)
data.f <- data.f[order(data.f$gene),]

L1List <- read.table(args[2],header=T)
data.f1 <- select(data.f,as.character(L1List$ID))

L1List2 <- read.table(args[3],header=T)
data.f2 <- select(data.f,as.character(L1List2$ID))


ra.df <- data.frame(Class10 = data.ao$Class10)
ra.df$Class10 <- factor(ra.df$Class10,level=Class10_l)
ra <- rowAnnotation(df = ra.df,
                    col = list(Class10 = c("ALLhigh" = "pink","ALLlow" = "skyblue",
                                               "VIRUShigh" = "green","LPShigh" = "orange",
                                               "Bhigh" = "red","Blow" = "black","TNKhigh" = "white","TNKlow" = "blue",
                                               "MONOhigh" = "yellow","MONOlow" = "purple","Others" = "aquamarine","N_A" = "gray50"
                                               )))

Cell_l <- c("B" = "pink","TNK" = "green","Mono" = "orange")
Species_l <- c("Homo_sapiens" = "pink","Pan_troglodytes" = "skyblue",
               "Macaca_mulatta" = "green","Rousettus_aegyptiacus" = "orange")
Stim_l <- c("Virus" = "skyblue","LPS" = "orange")
L1_l <- c("L1_1" = "pink","L1_2" = "skyblue","L1_3" = "green")


has <- HeatmapAnnotation(
  L1 = as.character(L1List2$L1),
  Stim = as.character(L1List2$Stim),
  CellType = as.character(L1List2$Cell),
  col= list(L1 = L1_l,Stim = Stim_l,CellType = Cell_l))

htss <- Heatmap(as.matrix(data.f2),right_annotation = ra,
               top_annotation=has,
               show_row_names=F,show_column_names=F,cluster_columns=F,cluster_rows=F,
               row_dend_width = unit(2, "cm"),name = "L1_Stim",row_names_gp = gpar(fontsize=6),
               col = colorRamp2(c(-1,0,1),c("blue","white","red")))

pdf(args[5],height=5,width=5)
draw(htss)
dev.off()

saveRDS(data.ao,args[6])

