#!/usr/bin/env R

args <- commandArgs(T)
library(ggplot2)
library(ComplexHeatmap)
library(amap)
library(circlize)
library(tidyverse)

Class10_l <- c("ALLhigh","ALLlow","VIRUShigh","LPShigh","Bhigh","Blow","TNKhigh","TNKlow","MONOhigh","MONOlow","N_A")
Class31_l <- c("ALLhigh","ALLlow",
               "VIRUShigh","LPSlow","VIRUSlow","LPShigh",
               "Bhigh","TNKMlow","Blow","TNKMhigh",
               "TNKhigh","BMlow","TNKlow","BMhigh",
               "Mhigh","BTNKlow","Mlow","BTNKhigh",
               "N_A")
data <- readRDS(args[1])
mt <- readRDS(args[2])
Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("HSV1","SeV","LPS")
Cell_l <- c("B","NaiveT","KillerTNK","Mono")

data.a <- readRDS(args[3])
rownames(data.a) <- data.a$gene
data.f <- data[rownames(data) %in% rownames(data.a),]
data.f <- as.data.frame(data.f)

mt.f <- mt[mt$Species == "Macaca_mulatta",]
data.ff <- data.f[,colnames(data.f) %in% mt.f$ID]
data.a$gene <- factor(rownames(data.a),level = rownames(data.ff))
data.a <- data.a[order(data.a$gene),]
data.a$sum <- apply(data.ff,1,mean)

data.a$Class18 <- factor(data.a$Class18,level=Class31_l)
data.a$Class10 <- factor(data.a$Class10,level=Class10_l)
data.ao <- data.a[order(data.a$Class18,data.a$sum),]
saveRDS(data.ao,args[5])

data.f$gene <- factor(rownames(data.f),level = rownames(data.ao))
data.f <- data.f[order(data.f$gene),]
data.f <- data.f[,1:(ncol(data.f)-1)]


ra.df <- data.frame(Class10 = data.ao$Class10,Class18 = data.ao$Class18)
ra.df$Class10 <- factor(ra.df$Class10,level=Class10_l)
ra.df$Class18 <- factor(ra.df$Class18,level=Class31_l)

ra <- rowAnnotation(df = ra.df,
                      col=list(Class18 = c("ALLhigh" = "pink","ALLlow" = "skyblue",
                                           "VIRUShigh" = "green","LPSlow" = "gray","VIRUSlow"="brown","LPShigh" = "orange",
                                           "Bhigh" = "red","TNKMlow"="darkgreen","Blow" = "black","TNKMhigh"="aquamarine",
                                           "TNKhigh" = "white","BMlow"="deeppink","TNKlow" = "blue","BMhigh"="yellow3",
                                           "Mhigh" = "yellow","BTNKlow"="purple4","Mlow" = "purple","BTNKhigh"="gray50",
                                           "N_A" = "gray50"
                                               ),
                               Class10 = c("ALLhigh" = "pink","ALLlow" = "skyblue",
                                               "VIRUShigh" = "green","LPShigh" = "orange",
                                               "Bhigh" = "red","Blow" = "black","TNKhigh" = "white","TNKlow" = "blue",
                                               "MONOhigh" = "yellow","MONOlow" = "purple","N_A" = "gray50"
                                               )))

ha <- HeatmapAnnotation(
  Species = mt$Species,
  Stim = mt$Stim,
  SixCellType = mt$SixCellType,
  col= list(
  Species = c("Homo_sapiens" = "pink","Pan_troglodytes" = "skyblue","Macaca_mulatta" = "green","Rousettus_aegyptiacus" = "orange"),
  Stim = c("HSV1" = "skyblue","SeV" = "green","LPS" = "orange"),
  SixCellType = c("B" = "pink","NaiveT" = "skyblue","KillerTNK" = "green","Mono" = "orange")
  )
)


hts <- Heatmap(as.matrix(data.f),top_annotation = ha,right_annotation = ra,
               cluster_columns=F,#as.dendrogram(c1),
               show_row_names=F,
               cluster_rows=F,#as.dendrogram(c2),
               row_dend_width = unit(2, "cm"),
               column_dend_height = unit(4, "cm"),
               name = "Exp",
               row_names_gp = gpar(fontsize=6),
               col = colorRamp2(c(-1,0,1),c("blue","white","red")))

pdf(args[4],height=6,width=8)
draw(hts)
dev.off()


