#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(future)
plan("multicore",workers=12)
options(future.globals.maxSize = 32000000000)
set.seed(1)

Mock <- readRDS(args[1])
HSV1 <- readRDS(args[2])
SeV  <- readRDS(args[3])
LPS  <- readRDS(args[4])

Seurat <- merge(Mock, y=c(HSV1,SeV,LPS),
  add.cell.ids=c("Mock","HSV1","SeV","LPS"), project=args[5])
mt <- Seurat@meta.data
Seurat.n <- NormalizeData(Seurat,verbose=F)
Virus_counts <- FetchData(Seurat.n,c("SeV","HSV1"),slot="counts")
colnames(Virus_counts) <- paste("counts_",colnames(Virus_counts),sep="_")
Virus_CP10k <- FetchData(Seurat.n,c("SeV","HSV1"),slot="data")
colnames(Virus_CP10k) <- paste("CP10k_",colnames(Virus_CP10k),sep="_")
mt <- cbind(mt,Virus_counts)
mt <- cbind(mt,Virus_CP10k)
Seurat@meta.data <- mt
Seurat <- Seurat[rownames(Seurat) != "SeV",]
Seurat <- Seurat[rownames(Seurat) != "HSV1",]

Seurat.s <- SplitObject(Seurat,split.by = "Stim")
for (i in 1:length(Seurat.s)) {
  Seurat.s[[i]] <- SCTransform(Seurat.s[[i]],verbose=F)
}
Seurat.features <- SelectIntegrationFeatures(object.list = Seurat.s, nfeatures = 2000)
Seurat.s <- PrepSCTIntegration(object.list = Seurat.s, anchor.features = Seurat.features)
reference_dataset <- which(names(Seurat.s) == "Mock")
combined <- FindIntegrationAnchors(Seurat.s, normalization.method = "SCT", 
    anchor.features = Seurat.features, reference = reference_dataset,verbose=F)
combined <- IntegrateData(combined, normalization.method = "SCT",verbose=F)
combined <- RunPCA(combined)
combined$Stim <- factor(combined$Stim,levels=c("Mock","HSV1","SeV","LPS"))

###########################################################################
saveRDS(combined@meta.data,args[6])
saveRDS(combined@assays$RNA,args[7])
saveRDS(combined@assays$SCT,args[8])
saveRDS(combined@assays$integrated,args[9])

combined@assays$dummy <- combined@assays$RNA
combined@active.assay <- "dummy"
combined@assays$RNA <- NULL
combined@assays$SCT <- NULL
combined@assays$integrated <- NULL

dummy.m <- combined@assays$dummy@counts
dummy.m@i <- integer(0)
dummy.m@p <- integer(0)
dummy.m@x <- integer(0)
combined@assays$dummy@counts <- dummy.m
combined@assays$dummy@data <- dummy.m
saveRDS(combined,args[10])




