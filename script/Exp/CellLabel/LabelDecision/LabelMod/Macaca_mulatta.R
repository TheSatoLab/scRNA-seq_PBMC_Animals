#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
mt <- read.table(args[1],header=T,sep="\t")
mt[4,2]  <- "NK"
mt[5,2]  <- "B_Naive"
mt[7,2]  <- "Mono2"
mt[11,2] <- "CD4T_Naive"
mt[13,2] <- "CD4T_nonNaive"
mt[15,2] <- "CD4T_nonNaive"
mt[16,2] <- "B_Naive"
mt[17,2] <- "CD8T_Naive"
mt[19,2] <- "Others"
mt[21,2] <- "CD4T_Naive"
mt[23,2] <- "NK"
mt[24,2] <- "NK"
mt[28,2] <- "Mono1"
mt <- mt[,c("BasicClusterID","predicted.id")]
colnames(mt) <- c("BasicClusterID","ClusterLabel")
write.table(mt,args[2],quote=F,row.names=F,sep="\t")


