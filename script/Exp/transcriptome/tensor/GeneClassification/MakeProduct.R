#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(rTensor)

out_l <- list()
tensor_l <- readRDS(args[1])
Cell_l <- c("B","NaiveT","KillerTNK","Mono")
Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("HSV1","SeV","LPS")

data_l <- list()
tensor <- tensor_l[["L1"]]
for (CC in Cell_l) {
  tensor_CC <- tensor[,,CC,]
  L1_l <- list()
  for (i in 1:3) {
    L1i <- tensor_CC[i,,]@data
    rownames(L1i) <- paste(dimnames(tensor_CC@data)[[1]][i],rownames(L1i),sep="__")
    L1_l[[i]] <- L1i
  }
  L1 <- rbind(L1_l[[1]],L1_l[[2]],L1_l[[3]])
  data_a <- t(L1)
  colnames(data_a) <- paste(CC,colnames(data_a),sep="__")
  data_l[[CC]] <- data_a
}
data <- cbind(data_l[[1]],data_l[[2]],data_l[[3]],data_l[[4]])#,data_l[[5]],data_l[[6]])
out_l[["L1"]] <- data

data_l <- list()
tensor <- tensor_l[["L2"]]
for (CC in Cell_l) {
  tensor_CC <- tensor[,,CC,]
  L_l <- list()
  for (i in 1:2) {
    Li <- tensor_CC[,i,]@data
    rownames(Li) <- paste(rownames(Li),dimnames(tensor_CC@data)[[2]][i],sep="__")
    L_l[[i]] <- Li
  }
  Ls <- rbind(L_l[[1]],L_l[[2]])
  data_a <- t(Ls)
  colnames(data_a) <- paste(CC,colnames(data_a),sep="__")
  data_l[[CC]] <- data_a
}
data <- cbind(data_l[[1]],data_l[[2]],data_l[[3]],data_l[[4]])
out_l[["L2"]] <- data


data_l <- list()
tensor <- tensor_l[["L3"]]
for (Species in Species_l) {
  tensor_CC <- tensor[Species,,,]
  L_l <- list()
  for (i in 1:3) {
    Li <- tensor_CC[,i,]@data
    L3id <- paste("L3_",i,sep="")
    rownames(Li) <- paste(L3id,Species,rownames(Li),sep="__")
    L_l[[i]] <- Li
  }
  Ls <- rbind(L_l[[1]],L_l[[2]],L_l[[3]])
  data_a <- t(Ls)
  data_l[[Species]] <- data_a
}
data <- cbind(data_l[[1]],data_l[[2]],data_l[[3]],data_l[[4]])
out_l[["L3"]] <- data

saveRDS(out_l,args[2])


