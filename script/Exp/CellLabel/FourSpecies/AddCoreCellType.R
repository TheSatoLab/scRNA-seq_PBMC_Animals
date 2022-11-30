#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)

mt <- readRDS(args[1])


return_CellType <- function(x) {switch(x,
  "B_Naive"     = "B_Naive",
  "B_nonNaive"  = "B_nonNaive",
  "Plasmablast" = "Others",
  "CD4T_Naive"    = "CD4T_Naive",
  "CD4TCM"        = "CD4T_nonNaive",
  "CD4T_nonNaive" = "CD4T_nonNaive",
  "CD4_CTL"       = "Others",
  "Treg"          = "CD4T_nonNaive",
  "CD8T_Naive"    = "CD8T_Naive",
  "CD8T_nonNaive" = "CD8T_nonNaive",
  "MAIT"  = "MAIT",
  "gdT"   = "Others",
  "dnT"   = "Others",
  "NK"    = "NK",
  "Mono1" = "Mono",
  "Mono2" = "Mono",
  "cDC"   = "cDC",
  "pDC"   = "pDC",
  "Others")}

return_ReducedCellType <- function(x) {switch(x,
  "B_Naive"     = "B",
  "B_nonNaive"  = "B",
  "CD4T_Naive"    = "NaiveT",
  "CD4T_nonNaive" = "NaiveT",
  "CD8T_Naive"    = "NaiveT",
  "CD8T_nonNaive" = "KillerTNK",
  "MAIT"  = "KillerTNK",
  "NK"    = "KillerTNK",
  "Mono" = "Mono",
  "cDC"   = "cDC",
  "pDC"   = "pDC",
  "Others")}


CoarseCellType_level <- c(
  "B_Naive","B_nonNaive",
  "CD4T_Naive","CD4T_nonNaive","CD8T_Naive","CD8T_nonNaive","MAIT","NK",
  "Mono","cDC","pDC",
  "Others"
  )


ReducedCellType_level <- c(
  "B","NaiveT","KillerTNK",
  "Mono","cDC","pDC","Others"
  )


mt$CoreClusterLabel <- factor(sapply(as.character(mt$ClusterLabel),return_CellType),level=CoarseCellType_level)
mt$SixCellType <- factor(sapply(as.character(mt$CoreClusterLabel),return_ReducedCellType),level=ReducedCellType_level)
saveRDS(mt,args[1])

