#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)
library(ComplexHeatmap)
library(circlize)
library(amap)

data <- readRDS(args[1])
data <- data[data$Class18 != "N_A",]
rownames(data) <- data$gene
Class10_l <- c("ALLhigh","ALLlow","VIRUShigh","LPShigh","Bhigh","Blow","TNKhigh","TNKlow","MONOhigh","MONOlow")
data$Class10 <- factor(data$Class10,level=Class10_l)
hdf <- select(data,-gene,-Class18,-Class10,-sum)
data$sum2 <- apply(hdf,1,sum)
data <- data[order(data$Class10,data$sum2),]
hdf <- select(data,-gene,-Class18,-Class10,-sum,-sum2)

ra.df <- data.frame(Class10 = data$Class10)
ra.df$Class10 <- factor(ra.df$Class10,level=Class10_l)
ra <- rowAnnotation(df = ra.df,
                    col = list(Class10 = c("ALLhigh" = "pink","ALLlow" = "skyblue",
                                               "VIRUShigh" = "green","LPShigh" = "orange",
                                               "Bhigh" = "red","Blow" = "black","TNKhigh" = "white","TNKlow" = "blue",
                                               "MONOhigh" = "yellow","MONOlow" = "purple"
                                               )))

Cell_l <- c("B" = "pink","TNK" = "brown","Mono" = "orange")
Stim_l <- c("Virus" = "darkblue","LPS" = "darkolivegreen1")

ha <- HeatmapAnnotation(
  Stim = c("Virus","Virus","Virus","LPS","LPS","LPS"),
  CellType = c("B","TNK","Mono","B","TNK","Mono"),
  col= list(Stim = Stim_l,CellType = Cell_l))

ht <- Heatmap(as.matrix(hdf),right_annotation = ra,
               top_annotation=ha,
               show_row_names=F,show_column_names=F,cluster_columns=F,cluster_rows=F,
               row_dend_width = unit(2, "cm"),name = "L1",row_names_gp = gpar(fontsize=6),
               col = colorRamp2(c(-1,0,1),c("blue","white","red")))

pdf(args[2],height=7,width=4)
draw(ht)
dev.off()

