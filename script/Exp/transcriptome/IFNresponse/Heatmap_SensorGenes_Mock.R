#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(ggplot2)
library(cowplot)
library(tidyverse)
library(ComplexHeatmap)
library(circlize)
library(RColorBrewer)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
#Stim_l <- c("Mock","HSV1","SeV","LPS")
CellType_l <- c("B_Naive","B_nonNaive","CD4T_Naive","CD4T_nonNaive","CD8T_Naive",
         "CD8T_nonNaive","MAIT","NK","Mono","cDC","pDC")
SixCellType_l <- c("B","NaiveT","KillerTNK","Mono","cDC","pDC")

pl <- list()
geneset <- read.table(args[1],header=T,sep="\t")
adf <- data.frame(Species = c(rep("Homo_sapiens",6),rep("Pan_troglodytes",6),
                                 rep("Macaca_mulatta",6),rep("Rousettus_aegyptiacus",6)),
                     SixCellType = rep(SixCellType_l,4))

adf$ID <- paste(adf$SixCellType,adf$Species,sep="__")
ID_levels <- adf$ID
df_l <- list()
for (Species in Species_l) {
  mt <- readRDS(paste(args[2],Species,"_metadata_SensorGenes.rds",sep=""))
  mt <- mt[mt$SixCellType %in% SixCellType_l,]
  mt <- mt[mt$Stim == "Mock",]
  mt$SixCellType <- factor(mt$SixCellType,level = SixCellType_l)
  mt$Species <- Species
  mt.f1 <- mt[,c("Species","Stim","SixCellType")]
  mt.f1$ID <- paste(mt.f1$SixCellType,mt.f1$Species,sep="__")
  mt.f2 <- mt[,colnames(mt) %in% geneset$Hs]
  mt.f2.scale <- as.data.frame(apply(mt.f2,2,scale,center=F))
  df <- as.data.frame(apply(mt.f2.scale,2,tapply,mt.f1$ID,mean))
  df_l[[Species]] <- df
}

gene_order <- colnames(df_l[["Homo_sapiens"]])
for (Species in Species_l) {
  df <- df_l[[Species]]
  df <- select(df,one_of(gene_order))
  df_l[[Species]] <- df
}
df <- rbind(df_l[["Homo_sapiens"]],df_l[["Pan_troglodytes"]],
            df_l[["Macaca_mulatta"]],df_l[["Rousettus_aegyptiacus"]])
df.m <- merge(adf,df,by.x="ID",by.y=0,all=T)
df.m$ID <- factor(df.m$ID,level=ID_levels)
df.m <- df.m[order(df.m$ID),]
rownames(df.m) <- df.m$ID

geneset.f <- geneset[geneset$Hs %in% colnames(df.m),]
geneset.f$Gene_Protein <- paste(geneset.f$Hs, geneset.f$Protein,sep="__")
hdf <- select(df.m,one_of(as.character(geneset.f$Hs)))
colnames(hdf) <- geneset.f$Gene_Protein
cdf <-df.m[,c("Species","SixCellType")]
cdf$Species <- factor(cdf$Species,levels = Species_l)
cdf$SixCellType <- factor(cdf$SixCellType,level = SixCellType_l)
rdf <- data.frame(Type = geneset.f$Type)
rownames(rdf) <- colnames(hdf)
rdf$Type <- factor(rdf$Type,level = c("TLR","NLR","CLR","RLR","DNA_sensor"))

ra <- rowAnnotation(
    df = rdf,
    col= list(Type= c("TLR" = "pink",
                      "NLR" = "skyblue",
                      "CLR" = "green",
                      "RLR" = "orange",
                      "DNA_sensor" = "black")))


cols_Species <- brewer.pal(4, "Dark2")

ca <- HeatmapAnnotation(
    df = cdf,
    col = list(Species = c("Homo_sapiens" = cols_Species[1],"Pan_troglodytes" = cols_Species[2],"Macaca_mulatta" = cols_Species[3],"Rousettus_aegyptiacus" = cols_Species[4]),
               SixCellType = c("B" = "pink","NaiveT" = "skyblue","KillerTNK" = "greenyellow","Mono" = "orange","cDC" = "red","pDC" = "grey"))
    )
ht <- Heatmap(as.matrix(log2(t(hdf)+1)),
    name = "Species",
    col = colorRamp2(c(0,0.01,1,4),c("white","seashell","red","black")),
    top_annotation = ca,
    left_annotation = ra,
    row_names_gp = gpar(fontsize=10),
    cluster_columns=F,cluster_rows=F,show_column_names=F)


cdf2 <- cdf[order(cdf$SixCellType),]
hdf2 <- select(as.data.frame(t(hdf)),one_of(rownames(cdf2)))
ca2 <- HeatmapAnnotation(
    df = cdf2,
    col = list(Species = c("Homo_sapiens" = cols_Species[1],"Pan_troglodytes" = cols_Species[2],"Macaca_mulatta" = cols_Species[3],"Rousettus_aegyptiacus" = cols_Species[4]),
               SixCellType = c("B" = "pink","NaiveT" = "skyblue","KillerTNK" = "greenyellow","Mono" = "orange","cDC" = "red","pDC" = "grey"))
    )
ht2 <- Heatmap(as.matrix(log2(hdf2+1)),
    name = "Cell",
    col = colorRamp2(c(0,0.01,1,4),c("white","seashell","red","black")),
    top_annotation = ca2,
    left_annotation = ra,
    row_names_gp = gpar(fontsize=10),
    cluster_columns=F,cluster_rows=F,show_column_names=F)

pdf(args[3],height=5,width=8)
draw(ht + ht2)
dev.off()





