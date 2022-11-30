#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)
library(ggplot2)

Hs <- read.table(args[1],header=T,sep="\t")
Hs <- mutate(Hs,Species = "Homo_sapiens")
Pt <- read.table(args[2],header=T,sep="\t")
Pt <- mutate(Pt,Species = "Pan_troglodytes")
Mm <- read.table(args[3],header=T,sep="\t")
Mm <- mutate(Mm,Species = "Macaca_mulatta")
Ra <- read.table(args[4],header=T,sep="\t")
Ra <- mutate(Ra,Species = "Rousettus_aegyptiacus")


CellRatio <- rbind(Hs,Pt,Mm,Ra)
CellRatio <- mutate(CellRatio,Species_Stim = paste(CellRatio$Species, CellRatio$Stim, sep="_"))
write.table(CellRatio,args[5],quote=F,row.names=F,sep="\t")


SSlevels <- paste(c(rep("Homo_sapiens",4),rep("Pan_troglodytes",4),
                    rep("Macaca_mulatta",4),rep("Rousettus_aegyptiacus",4)),
                  c(rep(c("Mock","HSV1","SeV","LPS"),4)), sep="_")
CellRatio$Species_Stim <- factor(CellRatio$Species_Stim,levels = SSlevels)
RowCluster_level <- c(
  "B_Naive","B_nonNaive","Plasmablast",
  "CD4T_Naive","CD4TCM","CD4_CTL","Treg","CD4T_nonNaive",
  "CD8T_Naive","CD8T_nonNaive",
  "MAIT","gdT","dnT","NK",
  "Mono1","Mono2","cDC","pDC","Others"
  )
CellRatio$Cluster <- factor(CellRatio$Cluster, levels = RowCluster_level)
CellRatio$Id <- as.numeric(CellRatio$Cluster)
CellRatio$Id_Cluster <- paste(CellRatio$Id,CellRatio$Cluster,sep="_")
Id_Cluster_levels <- paste(1:length(RowCluster_level),RowCluster_level,sep="_")
CellRatio$Id_Cluster <- factor(CellRatio$Id_Cluster,levels = Id_Cluster_levels)

p5 <- ggplot(CellRatio,aes(x=Species_Stim, y=Freq, fill=Id_Cluster))
p5 <- p5 + geom_bar(stat = "identity")
p5 <- p5 + geom_text(aes(x=Species_Stim,label=Id),size=2,vjust=1,position="stack")
p5 <- p5 + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

pdf(args[6],height=12, width=12)
print(p5)
dev.off()

