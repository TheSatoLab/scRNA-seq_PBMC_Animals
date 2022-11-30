#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(rTensor)

predata <- readRDS(args[1])

spn <- length(names(predata))
stn <- length(names(predata$Homo_sapiens))
can <- length(names(predata$Homo_sapiens$HSV1))
gen <- nrow(predata$Homo_sapiens$HSV1)
data <- array(NA,
              dim=c(gen,can,spn,stn),
              dimnames = list(rownames(predata$Homo_sapiens$HSV1),
                              names(predata$Homo_sapiens$HSV1),
                              names(predata),
                              names(predata$Homo_sapiens)))

for (Species in dimnames(data)[[3]]) {
  for (Stim in dimnames(data)[[4]]) {
    data[,,Species,Stim] <- as.matrix(predata[[Species]][[Stim]])
  }
}

dt <- as.tensor(aperm(data,perm=c(3,4,2,1)))
saveRDS(dt,args[2])


