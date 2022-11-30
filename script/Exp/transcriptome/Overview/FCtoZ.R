#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")
Stims_l <- c("HSV1","SeV","LPS")
Cell_l <- c("B","NaiveT","KillerTNK","Mono")

data <- readRDS(args[1])
FCZ_l <- list()

for (Species in Species_l) {
  FCZ_l[[Species]] <- list()
  for (Stim in Stims_l) {
    FCZ_l[[Species]][[Stim]] <- list()
    data.ss <- data[[Species]][[Stim]]
    data.log <- log2(data.ss)
    for (Ca in Cell_l) {
      FC.ssc <- data.log[,Ca]
      names(FC.ssc) <- rownames(data.log)
      noInf <- FC.ssc[!is.infinite(FC.ssc)]
      FC.ssc[is.infinite(FC.ssc)] <- min(noInf)
      FCZ_l[[Species]][[Stim]][[Ca]] <- scale(FC.ssc)
    }
    FCZ_l[[Species]][[Stim]] <- as.data.frame(FCZ_l[[Species]][[Stim]])
  }
}
saveRDS(FCZ_l,args[2])


