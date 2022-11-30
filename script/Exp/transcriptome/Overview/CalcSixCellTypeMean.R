#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")
Cell_l <- c("B","NaiveT","KillerTNK","Mono")

Bs <- c("B_Naive","B_nonNaive")
NaiveTs <- c("CD4T_Naive","CD4T_nonNaive","CD8T_Naive")
KillerTNKs <- c("CD8T_nonNaive","MAIT","NK")

data_l <- readRDS(args[1])
out_l <- list()
for (Species in Species_l) {
  out_l[[Species]] <- list()
  for (Stim in Stim_l) {
    data <- data_l[[Species]][[Stim]]
    data.B <- data[,Bs]
    data.NaiveT <- data[,NaiveTs]
    data.KillerTNK <- data[,KillerTNKs]
    out_l[[Species]][[Stim]][["B"]] <- apply(data.B,1,mean,na.rm=T)
    out_l[[Species]][[Stim]][["NaiveT"]] <- apply(data.NaiveT,1,mean,na.rm=T)
    out_l[[Species]][[Stim]][["KillerTNK"]] <- apply(data.KillerTNK,1,mean,na.rm=T)
    out_l[[Species]][[Stim]][["Mono"]] <- data$Mono
    out_l[[Species]][[Stim]] <- as.data.frame(out_l[[Species]][[Stim]])
  }
}
saveRDS(out_l,args[2])



