#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(tidyverse)

data <- readRDS(args[1])
L1List <- read.table(args[2],header=T)
L1List.2 <- L1List %>% filter(L1 == "L1_1")
data.2 <- select(as.data.frame(data),as.character(L1List.2$ID))

Threshold <- c(0.2,0.8)
df.q <- data.frame(
  "B__L1_1__Virus" = quantile(data.2[,"B__L1_1__Virus"],Threshold),
  "TNK__L1_1__Virus" = quantile(data.2[,"TNK__L1_1__Virus"],Threshold),
  "Mono__L1_1__Virus" = quantile(data.2[,"Mono__L1_1__Virus"],Threshold),
  "B__L1_1__LPS" = quantile(data.2[,"B__L1_1__LPS"],Threshold),
  "TNK__L1_1__LPS" = quantile(data.2[,"TNK__L1_1__LPS"],Threshold),
  "Mono__L1_1__LPS" = quantile(data.2[,"Mono__L1_1__LPS"],Threshold)
)
rownames(df.q) <- c("lowQ","highQ")
CheckQuantile <- function(x) {
  out_l <- list()
  for (ID in names(x)) {
    if (x[ID] >= df.q["highQ",ID]) {
      out_l[[ID]] <- 1
    } else if (x[ID] <= df.q["lowQ",ID]) {
      out_l[[ID]] <- -1
    } else {
      out_l[[ID]] <- 0
    }
  }
  out <- as.data.frame(out_l)
  rownames(out) <- rownames(x)
  return(t(out))
}
data.o <- t(as.data.frame(apply(data.2,1,CheckQuantile)))
colnames(data.o) <- colnames(data.2)
saveRDS(data.o,args[3])





