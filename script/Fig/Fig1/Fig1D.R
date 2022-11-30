#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)
library(ggplot2)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")
Cell_l <- c("B","NaiveT","KillerTNK","Mono","cDC","pDC")

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

return_ReducedCellType <- function(x) {switch(x,
  "B_Naive"     = "B",
  "B_nonNaive"  = "B",
  "CD4T_Naive"    = "NaiveT",
  "CD4T_nonNaive" = "NaiveT",
  "CD8T_Naive"    = "NaiveT",
  "CD8T_nonNaive" = "KillerTNK",
  "MAIT"  = "KillerTNK",
  "NK"    = "KillerTNK",
  "Mono" = "Mono",
  "cDC"   = "cDC",
  "pDC"   = "pDC",
  "Others")}

CellRatio$SixCellType <- sapply(as.character(CellRatio$CoarseCluster),return_ReducedCellType)
CellRatio <- CellRatio[CellRatio$SixCellType != "Others",]
#CellRatio <- select(CellRatio, -Cluster, -CoarseCluster)

CellRatio2 <- mutate(CellRatio,ID = paste(CellRatio$Species_Stim,CellRatio$SixCellType,sep="_")) %>%
  group_by(ID) %>%
  mutate(n2 = sum(n)) %>%
  select(-Cluster, -CoarseCluster,-n,-Freq) %>%
  unique %>%
  as.data.frame

SSsum <- tapply(CellRatio2$n2,CellRatio2$Species_Stim,sum)
data <- data.frame(matrix(rep(NA,7),nrow=1))[numeric(0),]
colnames(data) <- c(colnames(CellRatio2),"Freq")

for (SS in names(SSsum)) {
  data.ss <- CellRatio2[CellRatio2$Species_Stim == SS,]
  data.ss$Freq <- data.ss$n2/SSsum[SS]
  data <- rbind(data,data.ss)
}

SSlevels <- paste(c(rep("Homo_sapiens",4),rep("Pan_troglodytes",4),
                    rep("Macaca_mulatta",4),rep("Rousettus_aegyptiacus",4)),
                  c(rep(c("Mock","HSV1","SeV","LPS"),4)), sep="_")
data$Species_Stim <- factor(data$Species_Stim,levels = SSlevels)
data$SixCellType <- factor(data$SixCellType, levels = Cell_l)

colours <- c("B" = "pink","NaiveT" = "skyblue","KillerTNK" = "greenyellow","Mono" = "orange","cDC" = "orangered","pDC" = "gold3")

p5 <- ggplot(data,aes(x=Species_Stim, y=Freq, fill=SixCellType))
p5 <- p5 + geom_bar(stat = "identity") + scale_fill_manual(values=colours)
p5 <- p5 + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),panel.grid = element_blank(),
                    panel.background=element_rect("white")) 

pdf(args[2],height=6, width=6)
print(p5)
dev.off()


