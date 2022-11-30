#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

sensor <- read.table(args[1], header=T, check.names=F)
ortho <- read.table(args[2], header=T, check.names=F)
sensor.m <- left_join(sensor,ortho,by="Hs")
write.table(sensor.m,args[3],quote=F,sep="\t",row.names=F)


