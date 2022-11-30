#!/usr/bin/env R

args <- commandArgs(T)
library(ggplot2)
library(tidyverse)
library(cowplot)

up5 <- read.table(args[1],header=T,sep="\t")
up7 <- read.table(args[2],header=T,sep="\t")
down5 <- read.table(args[3],header=T,sep="\t")
down7 <- read.table(args[4],header=T,sep="\t")
up5 <- up5 %>% mutate(geneset = rownames(up5)) %>% top_n(10,oddsratio)
up7 <- up7 %>% mutate(geneset = rownames(up7)) %>% top_n(10,oddsratio)
down5 <- down5 %>% mutate(geneset = rownames(down5)) %>% top_n(10,oddsratio)
down7 <- down7 %>% mutate(geneset = rownames(down7)) %>% top_n(10,oddsratio)
up5$geneset <- factor(up5$geneset,level=rev(up5$geneset))
up7$geneset <- factor(up7$geneset,level=rev(up7$geneset))
down5$geneset <- factor(down5$geneset,level=rev(down5$geneset))
down7$geneset <- factor(down7$geneset,level=rev(down7$geneset))

pu5 <- ggplot(data = up5, aes(x = oddsratio,y=geneset)) + geom_bar(stat="identity") + ggtitle("up5")
pu7 <- ggplot(data = up7, aes(x = oddsratio,y=geneset)) + geom_bar(stat="identity") + ggtitle("up7")
pd5 <- ggplot(data = down5, aes(x = oddsratio,y=geneset)) + geom_bar(stat="identity") + ggtitle("down5")
pd7 <- ggplot(data = down7, aes(x = oddsratio,y=geneset)) + geom_bar(stat="identity") + ggtitle("down7")

p1 <- plot_grid(pu5,pd5,ncol=2,rel_widths=c(1,1))
p2 <- plot_grid(pu7,pd7,ncol=2,rel_widths=c(1,1))
p <- plot_grid(p1,p2,ncol=1,rel_heights=c(1,1))

pdf(args[5],height=6,width=24)
print(p)
dev.off()

