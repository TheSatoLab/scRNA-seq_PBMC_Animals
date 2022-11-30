#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(tidyverse)
library(ggplot2)

mt <- readRDS(args[1])
mt.f <- mutate(mt,CB = rownames(mt)) %>%
  select(CB,Stim,ClusterLabel)
mt.g <- group_by(mt.f,Stim,ClusterLabel) %>%
  summarise(n = n()) %>%
  mutate(freq = n/sum(n)) %>%
  as.data.frame()
colnames(mt.g) <- c("Stim","Cluster","n","Freq")
write.table(mt.g,args[2],quote=F,sep="\t",row.names=F)

p5 <- ggplot(mt.g,aes(x=Stim, y=Freq, fill=Cluster))
p5 <- p5 + geom_bar(stat = "identity")

pdf(args[3],height=10, width=7)
print(p5)
dev.off()

