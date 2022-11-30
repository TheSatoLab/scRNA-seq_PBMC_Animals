#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")

Exp <- readRDS(args[1])
for (Species in Species_l) {
  for (Stim in Stim_l) colnames(Exp[[Species]][[Stim]]) <- paste(Stim,colnames(Exp[[Species]][[Stim]]),sep="__") 
  Exp[[Species]] <- cbind(Exp[[Species]][[Stim_l[1]]],Exp[[Species]][[Stim_l[2]]],
                          Exp[[Species]][[Stim_l[3]]],Exp[[Species]][[Stim_l[4]]])
}
for (Species in Species_l) colnames(Exp[[Species]]) <- paste(Species,colnames(Exp[[Species]]),sep="__") 
Exp <- cbind(Exp[[Species_l[1]]],Exp[[Species_l[2]]],Exp[[Species_l[3]]],Exp[[Species_l[4]]])

mt <- as.data.frame(t(as.data.frame(strsplit(colnames(Exp),"__"))))
rownames(mt) <- colnames(Exp)
colnames(mt) <- c("Species","Stim","CellType")

data.m <- read.table(args[2],header=T,sep="\t")
data.m <- data.m %>% filter(Ra == "ALLhigh") %>% filter(Common == "ALLhigh") %>% select(gene,sum)
Exp.m <- merge(data.m,Exp,by.x="gene",by.y=0)
Exp.m$gene <- factor(Exp.m$gene,level=data.m$gene)
Exp.m <- Exp.m[order(Exp.m$gene),]
rownames(Exp.m) <- Exp.m$gene
Exp.m <- select(Exp.m,-gene,-sum)

saveRDS(Exp.m,args[3])
saveRDS(mt,args[4])


