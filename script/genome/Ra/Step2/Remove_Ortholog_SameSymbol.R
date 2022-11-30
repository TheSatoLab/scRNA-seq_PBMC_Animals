#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)

data <- read.table(args[1],header=T,sep="\t")
data.ortholog <- data[data$OrthologStatus == "Ortholog",]
data.f <- data[data$UniqueID %in% setdiff(data$UniqueID,data.ortholog$UniqueID),]
data.SameSymbol <- data.f[data.f$SymbolStatus == "SameSymbol",]
data.SameGene <- rbind(data.ortholog,data.SameSymbol)
write.table(data.SameGene,args[2],quote=F,sep="\t",row.names=F)

data.noOverlap <- data[data$OverlapStatus == "noOverlap",]
write.table(data.noOverlap,args[3],quote=F,sep="\t",row.names=F)

data.diff <- data[data$UniqueID %in% setdiff(data$UniqueID,data.SameGene$UniqueID),]
data.diff <- data.diff[data.diff$UniqueID %in% setdiff(data.diff$UniqueID,data.noOverlap$UniqueID),]
data.diff <- data.diff[data.diff$Bat1K %in% setdiff(data.diff$Bat1K,data.SameGene$Bat1K),]
data.diff <- data.diff[data.diff$gRefSeq %in% setdiff(data.diff$gRefSeq,data.SameGene$gRefSeq),]
write.table(data.diff,args[4],quote=F,sep="\t",row.names=F)



