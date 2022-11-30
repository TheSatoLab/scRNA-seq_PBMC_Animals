#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

data <- readRDS(args[1])
L1List <- read.table(args[2],header=T)
L1List.2 <- L1List %>% filter(L1 == "L1_2")
data.2 <- select(as.data.frame(data),as.character(L1List.2$ID))

AdjustData <- function(x) return(x/quantile(x,0.9))
data.adj <- as.data.frame(apply(data.2,2,AdjustData))
data.adj[data.adj >=  1] <-  1
data.adj[data.adj <= -1] <- -1

PatternList <- read.table(args[3],header=T,row.names=1)
CalcScore <- function(v1,v2) return(sum((v1-v2)^2))
ReturnScoreVector <- function(x)  return(apply(PatternList,1,CalcScore,x))
data.s <- as.data.frame(t(as.data.frame(apply(data.adj,1,ReturnScoreVector))))
data.s <- round(data.s,4)
saveRDS(data.s,args[4])




