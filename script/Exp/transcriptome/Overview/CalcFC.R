#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")
Stims_l <- c("HSV1","SeV","LPS")
Cell_l <- c("B","NaiveT","KillerTNK","Mono")

data <- readRDS(args[1])
FC_l <- list()
gene_l <- readRDS(args[2])

for (Species in Species_l) {
  FC_l[[Species]] <- list()
  data.Mock <- data[[Species]][["Mock"]]
  for (Stim in Stims_l) {
    FC_l[[Species]][[Stim]] <- list()
    data.ss <- data[[Species]][[Stim]]
    for (Ca in Cell_l) {
      FC.ssc <- data.ss[,Ca]/data.Mock[,Ca]
      names(FC.ssc) <- rownames(data.Mock)
      FC.ssc[is.nan(FC.ssc)] <- 0
      noInf <- FC.ssc[!is.infinite(FC.ssc)]
      FC.ssc[is.infinite(FC.ssc)] <- max(noInf)
      FC_l[[Species]][[Stim]][[Ca]] <- FC.ssc
    }
    FC.df <- as.data.frame(FC_l[[Species]][[Stim]])
    FC_l[[Species]][[Stim]] <- FC.df[rownames(FC.df) %in% gene_l,]
  }
}
saveRDS(FC_l,args[3])


