#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

mt <- readRDS(args[1])
mt.f <- mt %>%
  filter(Stim == "Mock") %>%
  select(BasicClusterID,predicted.id,predicted.id.score) %>%
  group_by(BasicClusterID,predicted.id) %>%
  summarise(n=n(), score.sum=sum(predicted.id.score)) %>%
  as.data.frame()
mt.f$score.mean <- mt.f$score.sum / mt.f$n
write.table(mt.f,args[2],sep="\t",quote=F,row.names=F)

MaxInCluster <- tapply(mt.f$score.sum,mt.f$BasicClusterID,max)
mt.m <- merge(as.data.frame(MaxInCluster),mt.f,by.x=0,by.y="BasicClusterID",all=T)
mt.m[is.na(mt.m)] <- 0
mt.mf <- mt.m[mt.m$score.sum == mt.m$MaxInCluster,]
mt.mf <- select(mt.mf,Row.names,predicted.id,score.mean)
colnames(mt.mf) <- c("BasicClusterID","predicted.id","score.mean")
mt.mf$BasicClusterID <- factor(as.numeric(mt.mf$BasicClusterID),levels = 1:nrow(mt.mf))
mt.mf <- mt.mf[order(mt.mf$BasicClusterID),]
write.table(mt.mf,args[3],sep="\t",quote=F,row.names=F)

