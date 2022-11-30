#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(future)
plan("multicore",workers=36)
options(future.globals.maxSize = 32000000000)
set.seed(1)

Hs <- readRDS(args[1])
Pt <- readRDS(args[2])
Mm <- readRDS(args[3])
Ra <- readRDS(args[4])

Seurat <- merge(Hs, y=c(Pt,Mm,Ra),
  add.cell.ids=c("Hs","Pt","Mm","Ra"), project=args[1])
Seurat <- Seurat[rownames(Seurat) != "SeVps",]
Seurat <- Seurat[rownames(Seurat) != "SeVns",]
Seurat <- Seurat[rownames(Seurat) != "HSV1ps",]
Seurat <- Seurat[rownames(Seurat) != "HSV1ns",]

Seurat.s <- SplitObject(Seurat,split.by = "orig.ident")
for (i in 1:length(Seurat.s)) {
  Seurat.s[[i]] <- SCTransform(Seurat.s[[i]],verbose=F)
}
Seurat.features <- SelectIntegrationFeatures(object.list = Seurat.s, nfeatures = 2000)
Seurat.s <- PrepSCTIntegration(object.list = Seurat.s, anchor.features = Seurat.features)
reference_dataset <- which(names(Seurat.s) == "Homo_sapiens_Mock")
combined <- FindIntegrationAnchors(Seurat.s, normalization.method = "SCT", 
    anchor.features = Seurat.features, reference = reference_dataset,verbose=F)
combined <- IntegrateData(combined, normalization.method = "SCT",verbose=F)
combined <- RunPCA(combined)
ChangeName <- function(x) {
  if (x == "Homo_sapiens_Mock") return("Hs")
  if (x == "Pan_troglodytes_Mock") return("Pt")
  if (x == "Macaca_mulatta_Mock") return("Mm")
  if (x == "Rousettus_aegyptiacus_Mock") return("Ra")
}
combined$Species <- sapply(combined$orig.ident,ChangeName)
combined$Species <- factor(combined$Species,levels=c("Hs","Pt","Mm","Ra"))
combined@assays$RNA <- NULL
combined@assays$SCT <- NULL
saveRDS(combined,args[5])

