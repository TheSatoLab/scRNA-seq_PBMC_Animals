#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)

data <- readRDS(args[1])
U3 <- t(data$A[[3]])
write.table(U3,args[2],sep="\t",quote=F)

