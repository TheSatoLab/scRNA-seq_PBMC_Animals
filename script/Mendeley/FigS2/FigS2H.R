#!/usr/bin/env R

args <- commandArgs(T)
library(amap)
library(tidyverse)

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
mt$ID <- paste(mt$Species,mt$Stim,mt$CellType,sep="__")
mt <- mt[,c("ID","Species","Stim","CellType","SixCellType")]

pca_res <- prcomp(t(Exp[rownames(Exp) %in% names(res_mad),]))
pca <- pca_res$x
dist_pca <- as.matrix(dist(pca[,1:30]))
colnames(dist_pca) <- paste("Dist",colnames(dist_pca),sep="__")

mt <- cbind(mt,dist_pca,pca[,1:30])
out <- rbind(as.data.frame(t(mt)),Exp[rownames(Exp) %in% names(res_mad),])
write.table(out,args[2],sep="\t",quote=F,col.names=F)




