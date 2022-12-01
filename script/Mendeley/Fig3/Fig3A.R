#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)

Species_l <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stim_l <- c("Mock","HSV1","SeV","LPS")
SixCellType_l <- c("B","NaiveT","KillerTNK","Mono","cDC","pDC")

mt <- readRDS(args[1])
mt$Species <- factor(mt$Species,level=Species_l)
mt$Stim <- factor(mt$Stim,level=Stim_l)
mt$CellType <- factor(mt$SixCellType,level = SixCellType_l)
mt <- na.omit(mt)
ReturnAbbr <- function(x) {
  switch(x,
    "Homo_sapiens" = "Hs",
    "Pan_troglodytes" = "Pt",
    "Macaca_mulatta" = "Mm",
    "Rousettus_aegyptiacus" = "Ra",
    "Others"
  )
}
mt$SpeciesAbbr <- sapply(as.character(mt$Species),ReturnAbbr)
mt$ID <- paste(mt$SpeciesAbbr,rownames(mt),sep="_")
out <- mt[,c("ID","Species","Stim","CellType","ISG")]
write.table(out,args[2],quote=F,sep="\t",row.names=F)


