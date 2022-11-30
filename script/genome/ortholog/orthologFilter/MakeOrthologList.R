#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)

HO_ID <- read.table(args[1],header=T)
O_IDsymbol <- read.table(args[2],header=T)
H_IDsymbol <- read.table(args[3],header=T)

OID.m <- merge(HO_ID, O_IDsymbol, by="Other_GeneID")
data <- merge(OID.m, H_IDsymbol, by="GeneID")
data <- data[,c("tax_id","GeneID","Hs_symbol","Other_tax_id","Other_GeneID","Other_symbol")]
write.table(data,args[4],sep="\t",quote=F, row.names=F)

