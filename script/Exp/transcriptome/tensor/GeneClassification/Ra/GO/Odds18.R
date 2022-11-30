#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

Class31_l <- c("ALLhigh","ALLlow",
               "VIRUShigh","LPSlow","VIRUSlow","LPShigh",
               "Bhigh","TNKMlow","Blow","TNKMhigh",
               "TNKhigh","BMlow","TNKlow","BMhigh",
               "Mhigh","BTNKlow","Mlow","BTNKhigh",
               "N_A")
Class18_l <- Class31_l[1:18]
data <- readRDS(args[1])
rownames(data) <- data$gene
totalgenes <- rownames(data)
geneset <- readRDS(args[2])
geneset.f <- list()

for (gs in names(geneset)) {
  genes.gs <- geneset[[gs]]
  genes.gsf <- genes.gs[genes.gs %in% totalgenes]
  if (length(genes.gsf) > 25) geneset.f[[gs]] <- genes.gsf
}


for (CC in Class18_l) {
  data.c <- data %>% filter(Class18 == CC)
  genes.cf <- rownames(data.c)
  res_l <- list()
  for (gs in names(geneset.f)) {
    genes.gs <- geneset.f[[gs]]
    CfGs <- length(intersect(genes.gs,genes.cf))
    if (CfGs == 0) next
    OgGs <- length(genes.gs) - CfGs
    CfOg <- length(genes.cf) - CfGs
    OgOg <- length(totalgenes) - CfGs - OgGs - CfOg
    mat <- matrix(c(CfGs,OgGs,CfOg,OgOg),nrow=2)
    res <- fisher.test(mat)
    res_l[[gs]] <- c(res$p.value,as.numeric(res$estimate))
  }
  res <- t(as.data.frame(res_l))
  colnames(res) <- c("pval","oddsratio")
  res <- as.data.frame(res)
  res$padj <- p.adjust(res$pval,method="BH")
  res <- res[order(res$oddsratio,decreasing=T),]
  write.table(res,paste(args[3],CC,".txt",sep=""),sep="\t",quote=F)

  res.f <- res[res$padj <= 0.1,]
  res.f <- res.f[res.f$oddsratio >= 1,]
  res.f <- res.f[order(res.f$oddsratio,decreasing=T),]
  write.table(res.f,paste(args[4],CC,".txt",sep=""),sep="\t",quote=F)
}



