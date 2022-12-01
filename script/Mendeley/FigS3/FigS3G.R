#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

data <- readRDS(args[1])
data <- data[data$Class18 != "N_A",]
rownames(data) <- data$gene
Class10_l <- c("ALLhigh","ALLlow","VIRUShigh","LPShigh","Bhigh","Blow","TNKhigh","TNKlow","MONOhigh","MONOlow")
data$Class10 <- factor(data$Class10,level=Class10_l)
hdf <- select(data,-gene,-Class18,-Class10,-sum)
data$sum2 <- apply(hdf,1,sum)
data <- data[order(data$Class10,data$sum2),]
hdf <- select(data,-Class18,-Class10,-sum,-sum2)
write.table(hdf,args[2],quote=F,sep="\t",row.names=F)


