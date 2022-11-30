#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(rTensor)

L1_l <- c("L1_1","L1_2","L1_3")
tensor <- readRDS(args[1])
tensor.1 <- ttl(tensor$S,list(A2 = tensor$A$A2, A3 = tensor$A$A3, A4 = tensor$A$A4),ms=c(2,3,4))
dimnames(tensor.1@data) <- list(dimnames(tensor$S@data)[[1]],
                            rownames(tensor$A$A2),
                            rownames(tensor$A$A3),
                            rownames(tensor$A$A4))

tensor.Virus <- (tensor.1[,"HSV1",,] + tensor.1[,"SeV",,])/2
df.VB <- tensor.Virus[,"B",]@data
rownames(df.VB) <- paste("B",L1_l,"Virus",sep="__")
tensor.VTNK <- (tensor.Virus[,"NaiveT",] + tensor.Virus[,"KillerTNK",])/2
df.VTNK <- tensor.VTNK@data
rownames(df.VTNK) <- paste("TNK",L1_l,"Virus",sep="__")
df.VM <- tensor.Virus[,"Mono",]@data
rownames(df.VM) <- paste("Mono",L1_l,"Virus",sep="__")

tensor.LPS <- tensor.1[,"LPS",,]
df.LB <- tensor.LPS[,"B",]@data
rownames(df.LB) <- paste("B",L1_l,"LPS",sep="__")
tensor.LTNK <- (tensor.LPS[,"NaiveT",] + tensor.LPS[,"KillerTNK",])/2
df.LTNK <- tensor.LTNK@data
rownames(df.LTNK) <- paste("TNK",L1_l,"LPS",sep="__")
df.LM <- tensor.LPS[,"Mono",]@data
rownames(df.LM) <- paste("Mono",L1_l,"LPS",sep="__")

data <- rbind(df.VB,df.VTNK,df.VM,df.LB,df.LTNK,df.LM)
data  <- t(data)
saveRDS(data,args[2])


