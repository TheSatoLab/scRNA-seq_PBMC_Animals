#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(rTensor)

tensor <- readRDS(args[1])
tensor.1 <- ttl(tensor$S,list(A2 = tensor$A$A2, A3 = tensor$A$A3, A4 = tensor$A$A4),ms=c(2,3,4))
dimnames(tensor.1@data) <- list(dimnames(tensor$S@data)[[1]],
                            rownames(tensor$A$A2),
                            rownames(tensor$A$A3),
                            rownames(tensor$A$A4))
tensor.2 <- ttl(tensor$S,list(A1 = tensor$A$A1, A3 = tensor$A$A3, A4 = tensor$A$A4),ms=c(1,3,4))
dimnames(tensor.2@data) <- list(rownames(tensor$A$A1),
                            dimnames(tensor$S@data)[[2]],
                            rownames(tensor$A$A3),
                            rownames(tensor$A$A4))
tensor.3 <- ttl(tensor$S,list(A1 = tensor$A$A1, A2 = tensor$A$A2, A4 = tensor$A$A4),ms=c(1,2,4))
dimnames(tensor.3@data) <- list(rownames(tensor$A$A1),
                            rownames(tensor$A$A2),
                            dimnames(tensor$S@data)[[3]],
                            rownames(tensor$A$A4))
out_l <- list("L1" = tensor.1,"L2" = tensor.2,"L3" = tensor.3)
saveRDS(out_l,args[2])


