#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
mt <- read.table(args[1],header=T,sep="\t")
mt[1,2]   <- "NK"
mt[2,2]   <- "Mono1"
mt[4,2]   <- "B_Naive"
mt[6,2]   <- "B_Naive"
mt[12,2]  <- "CD4T_Naive"
mt[13,2]  <- "CD4T_nonNaive"
mt[15,2]  <- "B_Naive"
mt[18,2]  <- "NK"
mt[19,2]  <- "Mono1"
mt[21,2]  <- "B_Naive"
mt[22,2]  <- "CD4T_nonNaive"
mt[23,2]  <- "cDC"
mt[25,2]  <- "NK"
mt[26,2]  <- "CD4T_nonNaive"
mt[27,2]  <- "B_nonNaive"
mt[28,2]  <- "Mono1"
mt[30,2]  <- "NK"
mt <- mt[,c("BasicClusterID","predicted.id")]
colnames(mt) <- c("BasicClusterID","ClusterLabel")
write.table(mt,args[2],quote=F,row.names=F,sep="\t")


