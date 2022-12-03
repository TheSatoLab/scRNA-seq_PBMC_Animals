#!/usr/bin/env R

args <- commandArgs(T)
library(tidyverse)

up <- read.table(args[1],header=T,sep="\t")
down <- read.table(args[2],header=T,sep="\t")
up <- up %>% mutate(geneset = rownames(up)) %>% mutate(UpDown = "Up") %>% select(geneset,UpDown,oddsratio,pval,padj)
down <- down %>% mutate(geneset = rownames(down)) %>% mutate(UpDown = "Down") %>% select(geneset,UpDown,oddsratio,pval,padj)
out <- rbind(up,down)
write.table(out,args[3],sep="\t",quote=F,row.names=F)


