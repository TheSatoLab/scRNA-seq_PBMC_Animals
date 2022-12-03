#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

data <- readRDS(args[1])
DEG <- read.table(args[2],header=T,sep="\t")
BP <- readRDS(args[3])
CP <- readRDS(args[4])
ortho <- read.table(args[5],header=T,sep="\t")
ortho <- ortho[ortho$Ra %in% rownames(data$C5),]
totalgenes <- ortho$Hs

geneset.f <- list()
for (gs in names(BP)) {
  genes.gs <- BP[[gs]]
  genes.gsf <- genes.gs[genes.gs %in% totalgenes]
  if (length(genes.gsf) > 25) geneset.f[[gs]] <- genes.gsf
}
for (gs in names(CP)) {
  genes.gs <- CP[[gs]]
  genes.gsf <- genes.gs[genes.gs %in% totalgenes]
  if (length(genes.gsf) > 25) geneset.f[[gs]] <- genes.gsf
}

for (CC in c("C5","C7")) {
  if (CC == "C5") cc <- 5
  if (CC == "C7") cc <- 7
  DEG.c <- DEG %>% filter(Cluster == cc)
  ortho.c <- ortho[ortho$Ra %in% DEG.c$gene,]
  genes.cf <- ortho.c$Hs
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
  write.table(res,paste(args[6],CC,".txt",sep=""),sep="\t",quote=F)

  res.f <- res[res$padj <= 0.05,]
  res.f <- res.f[res.f$oddsratio >= 10,]
  res.f <- res.f[order(res.f$oddsratio,decreasing=T),]
  write.table(res.f,paste(args[7],CC,".txt",sep=""),sep="\t",quote=F)
}



