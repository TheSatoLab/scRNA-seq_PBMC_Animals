#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(cowplot)
library(tidyverse)

Hs_Mock <- readRDS(args[1])
Hs_HSV1 <- readRDS(args[2])
Hs_SeV  <- readRDS(args[3])
Hs_LPS  <- readRDS(args[4])
Pt_Mock <- readRDS(args[5])
Pt_HSV1 <- readRDS(args[6])
Pt_SeV  <- readRDS(args[7])
Pt_LPS  <- readRDS(args[8])
Mm_Mock <- readRDS(args[9])
Mm_HSV1 <- readRDS(args[10])
Mm_SeV  <- readRDS(args[11])
Mm_LPS  <- readRDS(args[12])
Ra_Mock <- readRDS(args[13])
Ra_HSV1 <- readRDS(args[14])
Ra_SeV  <- readRDS(args[15])
Ra_LPS  <- readRDS(args[16])

mt <- rbind(Hs_Mock,Hs_HSV1,Hs_SeV,Hs_LPS,
            Pt_Mock,Pt_HSV1,Pt_SeV,Pt_LPS,
            Mm_Mock,Mm_HSV1,Mm_SeV,Mm_LPS,
            Ra_Mock,Ra_HSV1,Ra_SeV,Ra_LPS)
colnames(mt) <- c("Identity","nCount_RNA","nFeature_RNA")

pf <- ggplot(mt,aes(x=Identity,y=nFeature_RNA,fill=Identity))
pf <- pf + geom_violin(show.legend=F) + ggtitle("nFeature_RNA")
pf <- pf + scale_y_log10()
pf <- pf + theme(axis.text.x = element_text(angle=90,vjust=0.5))

pc <- ggplot(mt,aes(x=Identity,y=nCount_RNA,fill=Identity))
pc <- pc + geom_violin(show.legend=F) + ggtitle("nCount_RNA")
pc <- pc + scale_y_log10()
pc <- pc + theme(axis.text.x = element_text(angle=90,vjust=0.5))

p <- plot_grid(pf,pc,ncol=2)

pdf(args[17],height=6,width=10)
print(p)
dev.off()

