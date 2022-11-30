#!/usr/bin/env R

args <- commandArgs(T)

predata <- readRDS(args[1])

spn <- length(names(predata))
stn <- length(names(predata$Homo_sapiens))
can <- length(names(predata$Homo_sapiens$HSV1))
gen <- nrow(predata$Homo_sapiens$HSV1)

Species_level <- c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus")
Stims_level <- c("HSV1","SeV","LPS")

data <- as.data.frame(matrix(rep(NA,gen),ncol=gen))[numeric(0),]
colnames(data) <- rownames(predata$Homo_sapiens$HSV1)

mt <- as.data.frame(matrix(rep(NA,4),ncol=4))[numeric(0),]
colnames(mt) <- c("ID","Species","Stim","CellType")

j <- 1
for (Species in Species_level) {
  for (Stim in Stims_level) {
    data.ss <- t(predata[[Species]][[Stim]])
    mt.ss <- data.frame(ID = paste("ID",j:(j+nrow(data.ss)-1),sep="_"),
                         Species = rep(Species,nrow(data.ss)),
                         Stim=rep(Stim,nrow(data.ss)),
                         CellType = rownames(data.ss))
    mt <- rbind(mt,mt.ss)
    rownames(data.ss) <- mt.ss$ID
    data <- rbind(data,data.ss)
    j <- j + nrow(data.ss)
  }
}
data <- t(data)
saveRDS(data,args[2])

mt$Species <- factor(mt$Species,level=c("Homo_sapiens","Pan_troglodytes","Macaca_mulatta","Rousettus_aegyptiacus"))
mt$Stim <- factor(mt$Stim,level=c("HSV1","SeV","LPS"))
mt$SixCellType <- factor(mt$CellType,level=c("B","NaiveT","KillerTNK","Mono"))
write.table(mt,args[3],quote=F,sep="\t",row.names=F)
saveRDS(mt,args[4])



