#!/usr/bin/env R

args <- commandArgs(T)
library(ggplot2)
library(ComplexHeatmap)
library(amap)
library(circlize)
library(tidyverse)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("HSV1","SeV","LPS")
Stim4_l <- c("Mock","HSV1","SeV","LPS")
Cell_l <- c("B","NaiveT","KillerTNK","Mono")

Exp <- readRDS(args[1])
mt <- readRDS(args[2])
mt <- mt[mt$Species %in% c("Homo_sapiens","Rousettus_aegyptiacus"),]
Exp <- Exp[,colnames(Exp) %in% rownames(mt)]
Exp.v <- table(apply(Exp,1,c))[2]
Exp[Exp == 0] <- as.numeric(names(Exp.v))

data_l <- list()
for (ID in rownames(mt)) {
  mt.f <- mt[rownames(mt) == ID,]
  mt.Hs <- mt %>% filter(Species == "Homo_sapiens") %>% filter(CellType == mt.f$CellType) %>% filter(Stim == mt.f$Stim)
  data_l[[ID]] <- Exp[,rownames(mt.f)]/Exp[,rownames(mt.Hs)]
}
data <- log2(as.data.frame(data_l))
rownames(data) <- rownames(Exp)
mt.nonHs <- mt %>% filter(Species != "Homo_sapiens")
data <- data %>% select(one_of(rownames(mt.nonHs)))

mt.Mock <- mt.nonHs %>% filter(Stim == "Mock")
mt.Stim <- mt.nonHs %>% filter(Stim != "Mock")
data.Mock <- data %>% select(one_of(rownames(mt.Mock)))
data.Stim <- data %>% select(one_of(rownames(mt.Stim)))

data <- cbind(data.Mock,data.Stim)
mt.nonHs <- rbind(mt.Mock,mt.Stim)

ha <- HeatmapAnnotation(
  Species = mt.nonHs$Species,
  Stim = mt.nonHs$Stim,
  CellType = mt.nonHs$CellType,
  col= list(
  Species = c("Homo_sapiens" = "pink","Pan_troglodytes" = "skyblue","Macaca_mulatta" = "green","Rousettus_aegyptiacus" = "orange"),
  Stim = c("Mock" = "pink","HSV1" = "skyblue","SeV" = "green","LPS" = "orange"),
  CellType = c("B" = "pink","NaiveT" = "skyblue","KillerTNK" = "green","Mono" = "orange")
  )
)


hte <- Heatmap(as.matrix(data),top_annotation = ha,#right_annotation = ra,
               cluster_columns=F,#as.dendrogram(c1),
               show_row_names=T,show_column_names=F,
               cluster_rows=T,#as.dendrogram(c2),
               name = "Exp",
               row_names_gp = gpar(fontsize=6),
               col = colorRamp2(c(-2,0,2),c("blue","white","red")))

pdf(args[3],height=6,width=6)
draw(hte)
dev.off()








