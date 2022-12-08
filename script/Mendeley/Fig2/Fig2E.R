#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)

GC_l <- c("ALLhigh","ALLlow","VIRUShigh","LPShigh","Bhigh","Blow","TNKhigh","TNKlow","MONOhigh","MONOlow")

data_l <- list()
for (GC in GC_l) {
  res <- read.table(paste(args[1],GC,".txt",sep=""))
  res$GC <- GC
  res$geneset <- rownames(res)
  res.f <- res[res$padj <= 0.1,]
  res.f <- res.f[res.f$oddsratio >= 1,]
  res$status <- ifelse(rownames(res) %in% rownames(res.f),"enrich","NS")
  data <- select(res,GC,status,geneset,oddsratio,pval,padj)
  data_l[[GC]] <- data
}
out <- rbind(data_l[[1]],data_l[[2]],data_l[[3]],data_l[[4]],data_l[[5]],
             data_l[[6]],data_l[[7]],data_l[[8]],data_l[[9]],data_l[[10]])
write.table(out,args[2],sep="\t",quote=F,row.names=F)


