#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)

Bat1K <- read.table(args[1],header=T,sep="\t")
BlackList <- read.table(args[2],header=T,sep="\t")
ChrName <- read.table(args[3],header=F,sep="\t")
colnames(ChrName) <- c("Bat1K","RefSeq")

Bat1K.noBlackList <- Bat1K[Bat1K$gene_id %in% setdiff(Bat1K$gene_id,BlackList$gene),]
Bat1K.m <- left_join(Bat1K.noBlackList,ChrName,by=c("seqname"="Bat1K"))
Bat1K.o <- select(Bat1K.m,RefSeq,source,feature,start,end,score,strand,frame,gene_id)
colnames(Bat1K.o) <- c("seqname","source","feature","start","end","score","strand","frame","gene")
write.table(Bat1K.o,args[4],quote=F,sep="\t",row.names=F)

Bat1K.bed <- select(Bat1K.o,seqname,start,end,gene,score,strand)
Bat1K.bed$start <- Bat1K.bed$start - 1 
write.table(Bat1K.bed,args[5],sep="\t",quote=F,row.names=F,col.names=F)




