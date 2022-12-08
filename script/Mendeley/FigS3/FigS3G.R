#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)

mt <- readRDS(args[1])
mt <- mt[,c("ID","Species","Stim","CellType")]
rownames(mt) <- mt$ID

data.ao <- readRDS(args[2])
data.ao <- data.ao[data.ao$Class10 != "N_A",]
data.ao <- data.ao %>% select(-sum)
TDIDs <- data.frame(
  ID = colnames(data.ao[4:9]),
  Species = "L1_1",
  Stim = c(rep("Virus",3),rep("LPS",3)),
  CellType = rep(c("B","TNK","Mono"),2)
)
headers <- data.frame(
  gene = "gene",
  Class18 = "Class18",
  Class10 = rep("Class10",4)
)
headers <- cbind(headers,t(TDIDs))
colnames(headers) <- colnames(data.ao)
TD <- rbind(headers,data.ao)
write.table(TD,args[3],quote=F,sep="\t",col.names=F)



