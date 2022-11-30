#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)
library(ggplot2)

CellRatio <- read.table(args[1],header=T,check.names=F,sep="\t")
return_CellType <- function(x) {switch(x,
  "B_Naive"     = "B_Naive",
  "B_nonNaive"  = "B_nonNaive",
  "Plasmablast" = "Others",
  "CD4T_Naive"    = "CD4T_Naive",
  "CD4TCM"        = "CD4T_nonNaive",
  "CD4T_nonNaive" = "CD4T_nonNaive",
  "CD4_CTL"       = "Others",
  "Treg"          = "CD4T_nonNaive",
  "CD8T_Naive"    = "CD8T_Naive",
  "CD8T_nonNaive" = "CD8T_nonNaive",
  "MAIT"  = "MAIT",
  "gdT"   = "Others",
  "dnT"   = "Others",
  "NK"    = "NK",
  "Mono1" = "Mono",
  "Mono2" = "Mono",
  "cDC"   = "cDC",
  "pDC"   = "pDC",
  "Others")}

CellRatio$CoarseCluster <- sapply(as.character(CellRatio$Cluster),return_CellType)
CellRatio <- mutate(CellRatio,ID = paste(CellRatio$Species_Stim,CellRatio$CoarseCluster,sep="_")) %>%
  group_by(ID) %>%
  mutate(n2 = sum(n)) %>%
  mutate(Freq2 = sum(Freq)) %>%
  select(-Cluster,-n,-Freq) %>%
  unique %>%
  as.data.frame 

SSlevels <- paste(c(rep("Homo_sapiens",4),rep("Pan_troglodytes",4),
                    rep("Macaca_mulatta",4),rep("Rousettus_aegyptiacus",4)),
                  c(rep(c("Mock","HSV1","SeV","LPS"),4)), sep="_")
CellRatio$Species_Stim <- factor(CellRatio$Species_Stim,levels = SSlevels)
CoarseCellType_level_noOthers <- c(
  "B_Naive","B_nonNaive",
  "CD4T_Naive","CD4T_nonNaive","CD8T_Naive","CD8T_nonNaive","MAIT","NK",
  "Mono","cDC","pDC")
CellRatio$CoarseCluster <- factor(CellRatio$CoarseCluster, levels = CoarseCellType_level_noOthers)

p5 <- ggplot(CellRatio,aes(x=Species_Stim, y=Freq2, fill=CoarseCluster))
p5 <- p5 + geom_bar(stat = "identity")
p5 <- p5 + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

pdf(args[2],height=6, width=6)
print(p5)
dev.off()


