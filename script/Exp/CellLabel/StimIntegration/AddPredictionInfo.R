#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

mt.a <- readRDS(args[1])
mt <- readRDS(args[2])
mt.f <- mutate(mt,Row.names=factor(rownames(mt),levels=rownames(mt)))

mt.af <- mutate(mt.a,Row.names = paste("Mock_",rownames(mt.a),sep="")) %>%
  select(Row.names,predicted.id.coarse,mapping.score,predicted.id.coarse.score)
colnames(mt.af) <- c("Row.names","predicted.id","mapping.score","predicted.id.score")
mt.m <- merge(mt.f,mt.af,by="Row.names",all=T)
mt.ms <- mt.m[order(mt.m$Row.names),]
rownames(mt.ms) <- mt.ms$Row.names
mt.ms <- mt.ms[,colnames(mt.ms) != "Row.names"]
saveRDS(mt.ms,args[3])

