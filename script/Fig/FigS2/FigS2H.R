#!/usr/bin/env R

args <- commandArgs(T)
library(ComplexHeatmap)
library(amap)
library(circlize)
library(tidyverse)
library(RColorBrewer)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("HSV1","SeV","LPS")
Stim4_l <- c("Mock","HSV1","SeV","LPS")
Cell_l <- c("B_Naive","B_nonNaive",
  "CD4T_Naive","CD4T_nonNaive","CD8T_Naive","CD8T_nonNaive","MAIT","NK",
  "Mono","cDC","pDC")
Cell6_l <- c("B","NaiveT","KillerTNK","Mono","cDC","pDC")

Exp <- readRDS(args[1])
for (Species in Species_l) {
  for (Stim in Stim4_l) colnames(Exp[[Species]][[Stim]]) <- paste(Stim,colnames(Exp[[Species]][[Stim]]),sep="__") 
  Exp[[Species]] <- cbind(Exp[[Species]][[Stim4_l[1]]],Exp[[Species]][[Stim4_l[2]]],
                          Exp[[Species]][[Stim4_l[3]]],Exp[[Species]][[Stim4_l[4]]])
}
for (Species in Species_l) colnames(Exp[[Species]]) <- paste(Species,colnames(Exp[[Species]]),sep="__") 
Exp <- cbind(Exp[[Species_l[1]]],Exp[[Species_l[2]]],Exp[[Species_l[3]]],Exp[[Species_l[4]]])
Exp <- Exp[,!is.na(Exp[1,])]

res_mad <- apply(Exp,1,mad)
res_mad <- res_mad[order(res_mad,decreasing=T)][1:5000]

mt <- as.data.frame(t(as.data.frame(strsplit(colnames(Exp),"__"))))
rownames(mt) <- colnames(Exp)
colnames(mt) <- c("Species","Stim","CellType")

ReturnSixCellType <- function(x) {
  switch(
    x,
    "B_Naive" = "B",
    "B_nonNaive" = "B",
    "CD4T_Naive" = "NaiveT",
    "CD4T_nonNaive" = "NaiveT",
    "CD8T_Naive" = "NaiveT",
    "CD8T_nonNaive" = "KillerTNK",
    "MAIT" = "KillerTNK",
    "NK" = "KillerTNK",
    "Mono" = "Mono",
    "cDC" = "cDC",
    "pDC" = "pDC"
  )
}
mt$SixCellType <- sapply(as.vector(mt$CellType),ReturnSixCellType)
mt$SixCellType <- factor(mt$SixCellType,level=c("B","NaiveT","KillerTNK","Mono","cDC","pDC"))

pca_res <- prcomp(t(Exp[rownames(Exp) %in% names(res_mad),]))
pca <- pca_res$x
dist_pca <- as.matrix(dist(pca[,1:30]))

d1 <- Dist(dist_pca, method="pearson",nbproc=24)
c1 <- hclust(d1, method="ward.D2")

cols_Species <- brewer.pal(4, "Dark2")
cols_Stim <- brewer.pal(6, "Set2")

ha <- HeatmapAnnotation(
  Species = factor(mt$Species,levels=Species_l),
  Stim = factor(mt$Stim,levels=Stim4_l),
  CellType = factor(mt$CellType,levels=Cell_l),
  SixCellType = factor(mt$SixCellType,levels=),
  col= list(
  Species = c("Homo_sapiens" = cols_Species[1],"Pan_troglodytes" = cols_Species[2],"Macaca_mulatta" = cols_Species[3],"Rousettus_aegyptiacus" = cols_Species[4]),
  Stim = c("Mock" = "grey", "HSV1" = cols_Stim[3],"SeV" = cols_Stim[4],"LPS" = cols_Stim[5]),
  CellType = c("B_Naive" = "plum","B_nonNaive" = "pink1","CD4T_Naive" = "cyan","CD4T_nonNaive" = "deepskyblue2",
         "CD8T_Naive" = "aquamarine","CD8T_nonNaive" = "aquamarine3","MAIT" = "olivedrab3","NK" = "green",
         "Mono" = "orange","cDC" = "orangered","pDC" = "gold3"),
  SixCellType = c("B" = "pink","NaiveT" = "skyblue","KillerTNK" = "greenyellow","Mono" = "orange","cDC" = "orangered","pDC" = "gold3")
  )
)
hts <- Heatmap(matrix(nc=ncol(dist_pca),nr=0),top_annotation = ha,
               cluster_columns=as.dendrogram(c1),
               show_row_names=F,
               show_column_names=F,
               #cluster_rows=as.dendrogram(c1),
               column_dend_height = unit(4, "cm"),
               name = "dist",width=unit(14,"cm"))

pdf(args[2],height=6,width=8)
draw(hts)
dev.off()






