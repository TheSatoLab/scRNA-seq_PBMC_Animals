#!/usr/bin/env R

args <- commandArgs(T)
library(ComplexHeatmap)
library(amap)
library(circlize)
library(RColorBrewer)

name_l <- c("Hs1","Hs2","Mm1","Mm2","Ra")
data_l <- list()

for (Name in name_l) {
  data.n <- read.table(paste(args[1],Name,".txt",sep=""),header=T,row.names=1)
  data.n <- data.n[c("HSV1_FE_ICP8","HSV1_FL_UL49_VP22","HSV1_F_IE_ICP27"),c("HSV1_0.1","HSV1_1.0","HSV1_10")]
  colnames(data.n) <- paste(Name,colnames(data.n),sep="__")
  data_l[[Name]] <- log2(data.n*1000)
}
data <- cbind(data_l[[1]],data_l[[2]],data_l[[3]],data_l[[4]],data_l[[5]])

cols_Species <- brewer.pal(4, "Dark2")
cols_ID <- brewer.pal(5, "Accent")
cols_Dose <- brewer.pal(4, "Greys")

ha <- HeatmapAnnotation(
  ID = c(rep("Hs1",3),rep("Hs2",3),rep("Mm1",3),rep("Mm2",3),rep("Ra",3)),
  Species = c(rep("Hs",3),rep("Hs",3),rep("Mm",3),rep("Mm",3),rep("Ra",3)),
  Dose = rep(c("0.1","1.0","10"),5),
  col= list(
  ID = c("Hs1" = cols_ID[1],"Hs2" = cols_ID[2],"Mm1" = cols_ID[3],"Mm2" = cols_ID[4],"Ra" = cols_ID[5]),
  Species = c("Hs" = cols_Species[1],"Mm" = cols_Species[3],"Ra" = cols_Species[4]),
  Dose = c("0.1" = cols_Dose[2],"1.0" = cols_Dose[3],"10" = cols_Dose[4])
  )
)

ht <- Heatmap(as.matrix(data),top_annotation = ha,
               cluster_columns=F,
               show_row_names=T,
               show_column_names=F,
               cluster_rows=F,
               name = "log2(ddCtx1000)",#width=unit(50,"cm"),
               row_names_gp = gpar(fontsize=6),
               col = colorRamp2(c(-10,0,10),c("blue","white","red")))

pdf(args[2],height=3,width=8)
draw(ht)
dev.off()



