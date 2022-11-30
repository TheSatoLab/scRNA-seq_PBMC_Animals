#!/usr/bin/env R

args <- commandArgs(T)
library(ComplexHeatmap)
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

mean_l <- list()
for (Stim in Stim4_l) {
  mt.s <- mt.nonHs[mt.nonHs$Stim == Stim,]
  data.s <- data %>% select(one_of(rownames(mt.s)))
  data.s.mean <- apply(data.s,1,mean)
  mean_l[[Stim]] <- data.s.mean
}
data.mean <- as.data.frame(mean_l)
data.mean.mean <- apply(data.mean,1,mean)
data.mean.mean <- data.mean.mean[order(data.mean.mean)]

df_l <- list()
for (Stim in Stim4_l) {
  df.s <- data.frame(Stim = Stim,
                     gene = rownames(data.mean),
                     log2FC_HsRa = data.mean[,Stim])
  df_l[[Stim]] <- df.s
}
df <- data.frame(Mock = df_l$Mock$log2FC_HsRa,HSV1 = df_l$HSV1$log2FC_HsRa,
                 SeV = df_l$SeV$log2FC_HsRa,LPS = df_l$LPS$log2FC_HsRa)
rownames(df) <- df_l$Mock$gene
df <- df[order(df$Mock),rev(Stim4_l)]


hte <- Heatmap(as.matrix(t(df)),#top_annotation = ha,#right_annotation = ra,
               cluster_columns=F,#as.dendrogram(c1),
               show_row_names=T,show_column_names=T,
               cluster_rows=F,#as.dendrogram(c2),
               name = "log2FC_HsRa",
               row_names_gp = gpar(fontsize=6),
               col = colorRamp2(c(-4,0,4),c("blue","white","red")))

pdf(args[3],height=2,width=7)
draw(hte)
dev.off()







