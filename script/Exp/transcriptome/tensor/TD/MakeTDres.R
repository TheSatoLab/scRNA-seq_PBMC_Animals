#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(rTensor)
library(tidyverse)
library(RcppCNPy)

data <- readRDS(args[1])
A1 <- npyLoad(args[2])
A2 <- npyLoad(args[3])
A3 <- npyLoad(args[4])
A4 <- npyLoad(args[5])
rank_1 <- ncol(A1)
rank_2 <- ncol(A2)
rank_3 <- ncol(A3)
rank_4 <- ncol(A4)
A <- list(A1 = t(A1),A2 = t(A2),A3 = t(A3),A4 = t(A4))
colnames(A[[1]]) <- names(data)
colnames(A[[2]]) <- names(data[[1]])
colnames(A[[3]]) <- colnames(data[[1]][[1]])
colnames(A[[4]]) <- rownames(data[[1]][[1]])
rownames(A[[1]]) <- paste("L1",1:rank_1,sep="_")
rownames(A[[2]]) <- paste("L2",1:rank_2,sep="_")
rownames(A[[3]]) <- paste("L3",1:rank_3,sep="_")
rownames(A[[4]]) <- paste("L4",1:rank_4,sep="_")

preS <- array(NA,
              dim=c(rank_1,rank_2,rank_3,rank_4),
              dimnames = list(rownames(A[[1]]),
                              rownames(A[[2]]),
                              rownames(A[[3]]),
                              rownames(A[[4]])))

for (L1 in rownames(A[[1]])) {
  for (L2 in rownames(A[[2]])) {
    corename <- paste(args[6],L1,"__",L2,".npy",sep="")
    pS <- npyLoad(corename)
    preS[L1,L2,,] <- pS
  }
}

S <- as.tensor(aperm(preS,perm=c(1,2,3,4)))
tensor <- list(S = S, A = A)
tensor$A$A1 <- t(tensor$A$A1)
tensor$A$A2 <- t(tensor$A$A2)
tensor$A$A3 <- t(tensor$A$A3)
tensor$A$A4 <- t(tensor$A$A4)
tensor$est <- ttl(tensor$S,tensor$A,ms=1:4)
input <- readRDS(args[8])
tensor$fnorm_resid <- fnorm(tensor$est - input)
saveRDS(tensor,args[7])





