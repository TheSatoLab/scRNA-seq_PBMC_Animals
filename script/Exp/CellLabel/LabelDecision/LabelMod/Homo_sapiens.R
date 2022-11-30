#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
mt <- read.table(args[1],header=T,sep="\t")
mt[5,2]  <- "CD4T_Naive"
mt[6,2]  <- "Mono1"
mt[15,2] <- "CD4T_Naive"
mt[17,2] <- "Mono1"
mt[23,2] <- "Mono2"
mt[24,2] <- "gdT"
mt[27,2] <- "CD8T_Naive"
mt <- mt[,c("BasicClusterID","predicted.id")]
colnames(mt) <- c("BasicClusterID","ClusterLabel")
write.table(mt,args[2],quote=F,row.names=F,sep="\t")


