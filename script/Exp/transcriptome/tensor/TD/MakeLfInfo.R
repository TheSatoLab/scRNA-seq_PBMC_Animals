#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(rTensor)
library(tidyverse)

tensor <- readRDS(args[1])
L1_num <- tensor$S@modes[1]
L2_num <- tensor$S@modes[2]
L3_num <- tensor$S@modes[3]

lf <- data.frame(L1 = c(rep(paste("L1",1,sep="_"),L3_num*L2_num),
                        rep(paste("L1",2,sep="_"),L3_num*L2_num),
                        rep(paste("L1",3,sep="_"),L3_num*L2_num)),
                 L2 = rep(c(rep(paste("L2",1,sep="_"),L3_num),
                        rep(paste("L2",2,sep="_"),L3_num)),L1_num),
                 L3 = rep(paste("L3",1:L3_num,sep="_"),L1_num*L2_num))


U1 <- as.data.frame(t(tensor$A[[1]]))
U1$L1 <- rownames(U1)
U2 <- as.data.frame(t(tensor$A[[2]]))
U2$L2 <- rownames(U2)
U3 <- as.data.frame(t(tensor$A[[3]]))
U3$L3 <- rownames(U3)
lf$L1__L2__L3 <- paste(lf$L1,lf$L2,lf$L3,sep="__")
var_v <- c()
for (L1 in colnames(tensor$A[[1]])) {
  for (L2 in colnames(tensor$A[[2]])) {
    for (L3 in colnames(tensor$A[[3]])) {
      var_v <- c(var_v,var(tensor$S@data[L1,L2,L3,]))
    }  
  }
}
lf$var <- var_v

lf.m <- left_join(lf,U1,by="L1")
lf.m <- left_join(lf.m,U2,by="L2")
lf.m <- left_join(lf.m,U3,by="L3")
rownames(lf.m) <- lf.m$L1__L2__L3
lf.m <- select(lf.m,-L1__L2__L3)
write.table(lf.m,args[2],quote=F,row.names=T,sep="\t")



