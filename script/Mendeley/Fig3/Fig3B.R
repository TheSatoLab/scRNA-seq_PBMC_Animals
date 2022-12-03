#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
CellType_l <- c("B_Naive","B_nonNaive","CD4T_Naive","CD4T_nonNaive","CD8T_Naive",
         "CD8T_nonNaive","MAIT","NK","Mono","cDC","pDC")
SixCellType_l <- c("B","NaiveT","KillerTNK","Mono","cDC","pDC")

geneset <- read.table(args[1],header=T,sep="\t")
geneset <- geneset[geneset$Hs != "CLEC6A",]
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
cdf$CellType <- factor(cdf$SixCellType,level = SixCellType_l)
cdf <- cdf[,c("Species","CellType")]
out <- rbind(t(cdf),as.data.frame(log2(t(hdf)+1)))
write.table(out,args[3],sep="\t",quote=F,col.names=F)





