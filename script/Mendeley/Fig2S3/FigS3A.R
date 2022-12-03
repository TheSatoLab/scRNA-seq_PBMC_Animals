#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)

data <- readRDS(args[1])
U2 <- t(data$A[[2]])
write.table(U2,args[2],sep="\t",quote=F)

