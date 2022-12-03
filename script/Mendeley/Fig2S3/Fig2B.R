#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)

data <- readRDS(args[1])
U1 <- t(data$A[[1]])
write.table(U1,args[2],sep="\t",quote=F)

