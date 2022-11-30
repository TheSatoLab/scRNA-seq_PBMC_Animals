#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)

Pt <- read.table(args[1],header=T,sep="\t")
Pt <- Pt[,c("Hs_symbol","Other_symbol")]
colnames(Pt) <- c("Hs","Pt")
Mm <- read.table(args[2],header=T,sep="\t")
Mm <- Mm[,c("Hs_symbol","Other_symbol")]
colnames(Mm) <- c("Hs","Mm")
Ra <- read.table(args[3],header=T,sep="\t")
Ra <- Ra[,c("Hs_symbol","Other_symbol")]
colnames(Ra) <- c("Hs","Ra")

df <- merge(Pt,Mm,by="Hs",all=T)
df <- merge(df,Ra,by="Hs",all=T)
write.table(df,args[4],quote=F,sep="\t",row.names=F)

