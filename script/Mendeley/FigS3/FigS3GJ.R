#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)

data <- readRDS(args[1])
mt <- readRDS(args[2])
mt <- mt[,c("ID","Species","Stim","CellType")]
rownames(mt) <- mt$ID

data.ao <- readRDS(args[3])
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

data.f <- data[rownames(data) %in% rownames(data.ao),]
data.f <- as.data.frame(data.f)
data.f$gene <- factor(rownames(data.f),level=data.ao$gene)
data.f <- data.f[order(data.f$gene),]
data.f <- data.f[,colnames(data.f) != "gene"]
data.f <- rbind(t(mt),data.f)

out <- cbind(TD,data.f)
out <- out %>% select(-gene)
write.table(out,args[4],quote=F,sep="\t",col.names=F)



