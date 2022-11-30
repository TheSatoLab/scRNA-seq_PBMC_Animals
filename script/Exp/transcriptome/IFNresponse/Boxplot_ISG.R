#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(ggplot2)
library(cowplot)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")
SixCellType_l <- c("B","NaiveT","KillerTNK","Mono","cDC","pDC")

mt <- readRDS(args[1])
mt$Species <- factor(mt$Species,level=Species_l)
mt$Stim <- factor(mt$Stim,level=Stim_l)
mt$SixCellType <- factor(mt$SixCellType,level = SixCellType_l)
mt <- na.omit(mt)

mt$SSC <- paste(mt$Species,mt$Stim,mt$SixCellType,sep="__")
colours <- c("B" = "pink","NaiveT" = "skyblue","KillerTNK" = "greenyellow","Mono" = "orange","cDC" = "orangered","pDC" = "gold3")

p3 <- ggplot(mt,aes(x=Stim,y=ISG,fill=SixCellType))
p3 <- p3 + geom_boxplot(outlier.shape = NA) + facet_wrap(~Species,scale="fixed",ncol=4)
p3 <- p3 + theme(text = element_text(size=30)) + scale_fill_manual(values=colours)
p3 <- p3 + ylim(-0.21,0.80) + ylab("totalISG")

pdf(args[2],height=4,width=20)
print(p3)
dev.off()



