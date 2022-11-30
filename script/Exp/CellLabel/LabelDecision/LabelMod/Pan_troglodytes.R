#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
mt <- read.table(args[1],header=T,sep="\t")
mt[3,2]   <- "B_Naive"
mt[7,2]   <- "Mono1"
mt[8,2]   <- "CD4T_Naive"
mt[10,2]  <- "NK"
mt[18,2]  <- "Mono1"
mt[20,2]  <- "Mono1"
mt[23,2]  <- "Mono1"
mt[26,2]  <- "CD8T_Naive"
mt <- mt[,c("BasicClusterID","predicted.id")]
colnames(mt) <- c("BasicClusterID","ClusterLabel")
write.table(mt,args[2],quote=F,row.names=F,sep="\t")


