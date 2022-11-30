#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library("RcppCNPy")

data <- readRDS(args[1])
Species_level <- c("Homo_sapiens","Pan_troglodytes",
                   "Macaca_mulatta","Rousettus_aegyptiacus")
Stim_level <- c("HSV1","SeV","LPS")

for (Species in Species_level) {
  for (Stim in Stim_level) {
    data_name <- paste(args[2],Species,"__",Stim,".npy",sep="")
    npySave(data_name,t(as.matrix(data[[Species]][[Stim]])))
  }
}




