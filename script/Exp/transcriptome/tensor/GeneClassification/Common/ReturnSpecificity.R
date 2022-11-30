#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

data <- readRDS(args[1])
L1List <- read.table(args[2],header=T)
L1List.2 <- L1List %>% filter(L1 == "L1_1")
data.2 <- select(as.data.frame(data),as.character(L1List.2$ID))

df.s <- readRDS(args[3])
df.q <- readRDS(args[4])
ScoreQ <- apply(df.s,2,quantile,0.2)

ReturnClass18 <- function(gene) {
  if (sum(df.q[gene,]) == 6) {
    return("ALLhigh")
  } else if (sum(df.q[gene,]) == -6) {
    return("ALLlow")
  ####################################################
  } else {
    Qinfo <- df.q[gene,]
    Candidate <- c()
    if (Qinfo[1] == 1 & Qinfo[2] == 1 & Qinfo[3] == 1) Candidate <- c(Candidate,"VIRUShigh")
    if (Qinfo[4] == -1 & Qinfo[5] == -1 & Qinfo[6] == -1) Candidate <- c(Candidate,"LPSlow")
    if (Qinfo[1] == -1 & Qinfo[2] == -1 & Qinfo[3] == -1) Candidate <- c(Candidate,"VIRUSlow")
    if (Qinfo[4] == 1 & Qinfo[5] == 1 & Qinfo[6] == 1) Candidate <- c(Candidate,"LPShigh")
      
    if (Qinfo[1] == 1 & Qinfo[4] == 1) Candidate <- c(Candidate,"Bhigh")
    if (Qinfo[2] == -1 & Qinfo[3] == -1 & Qinfo[5] == -1 & Qinfo[6] == -1) Candidate <- c(Candidate,"TNKMlow")
    if (Qinfo[1] == -1 & Qinfo[4] == -1) Candidate <- c(Candidate,"Blow")
    if (Qinfo[2] == 1 & Qinfo[3] == 1 & Qinfo[5] == 1 & Qinfo[6] == 1) Candidate <- c(Candidate,"TNKMhigh")
      
    if (Qinfo[2] == 1 & Qinfo[5] == 1) Candidate <- c(Candidate,"TNKhigh")
    if (Qinfo[1] == -1 & Qinfo[3] == -1 & Qinfo[4] == -1 & Qinfo[6] == -1) Candidate <- c(Candidate,"BMlow")
    if (Qinfo[2] == -1 & Qinfo[5] == -1) Candidate <- c(Candidate,"TNKlow")
    if (Qinfo[1] == 1 & Qinfo[3] == 1 & Qinfo[4] == 1 & Qinfo[6] == 1) Candidate <- c(Candidate,"BMhigh")
    
    if (Qinfo[3] == 1 & Qinfo[6] == 1) Candidate <- c(Candidate,"Mhigh")
    if (Qinfo[1] == -1 & Qinfo[2] == -1 & Qinfo[4] == -1 & Qinfo[5] == -1) Candidate <- c(Candidate,"BTNKlow")
    if (Qinfo[3] == -1 & Qinfo[6] == -1) Candidate <- c(Candidate,"Mlow")
    if (Qinfo[1] == 1 & Qinfo[2] == 1 & Qinfo[4] == 1 & Qinfo[5] == 1) Candidate <- c(Candidate,"BTNKhigh")

    if (length(Candidate) > 1) {
      Sinfo <- df.s[gene,colnames(df.s) %in% Candidate]
      FC <- c()
      for (CC in Candidate)  if (ScoreQ[CC] > df.s[gene,CC]) FC <- c(FC,CC)
      if (length(FC) > 1) {
        Sinfo.f <- df.s[gene,colnames(df.s) %in% FC]
        return(names(sort(Sinfo.f)[1]))
      } else if (length(FC) == 1) {
          return(FC)
      } else {
        return("N_A")
      }
    } else if (length(Candidate) == 1) {
      if (ScoreQ[Candidate] > df.s[gene,Candidate]) {
        return(Candidate)
      } else {
        return("N_A")
      }
    } else {
      return("N_A")
    }
  }
}
data.2$Class18 <- sapply(rownames(data.2),ReturnClass18)

ReturnClass10 <- function(x) {
  switch(x,
  "ALLhigh" = "ALLhigh",
  "ALLlow" = "ALLlow",
  
  "VIRUShigh" = "VIRUShigh",
  "LPSlow" = "VIRUShigh",
  "VIRUSlow" = "LPShigh",
  "LPShigh" = "LPShigh",
  
  "Bhigh" = "Bhigh",
  "TNKMlow" = "Bhigh",
  "Blow" = "Blow",
  "TNKMhigh" = "Blow",
  
  "TNKhigh" = "TNKhigh",
  "BMlow" = "TNKhigh",
  "TNKlow" = "TNKlow",
  "BMhigh" = "TNKlow",
  
  "Mhigh" = "MONOhigh",
  "BTNKlow" = "MONOhigh",
  "Mlow" = "MONOlow",
  "BTNKhigh" = "MONOlow",
  
  "N_A" = "N_A",
  "Others")
}
data.2$Class10 <- sapply(data.2$Class18,ReturnClass10)
data.2$gene <- rownames(data.2)
data.f <- select(data.2,gene,Class18,Class10)
data.o <- cbind(data.f,data.2[,1:6])
Class18_l <- c(colnames(df.s)[1:18],"N_A")
data.o$Class18 <- factor(data.o$Class18,level = Class18_l)
data.o <- data.o[order(data.o$Class18),]
write.table(data.o,args[5],quote=F,sep="\t",row.names=F)



