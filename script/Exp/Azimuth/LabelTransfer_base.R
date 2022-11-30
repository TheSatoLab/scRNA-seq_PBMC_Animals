#!/usr/bin/env R


LabelTransfer <- function(query,reference) {

# Preprocess with SCTransform
query <- SCTransform(
  object = query,
  assay = "RNA",
  residual.features = rownames(x = reference),
  method = 'glmGamPoi',
  ncells = 2000,
  n_genes = 2000,
  do.correct.umi = FALSE,
  do.scale = FALSE,
  do.center = TRUE,
  verbose = F
)

query <- RunPCA(query,verbose=F)
reference <- RunPCA(reference,verbose=F)

# Find anchors between query and reference
anchors <- FindTransferAnchors(
  reference = reference,
  query = query,
  reduction="cca",
  features = intersect(rownames(x = reference), VariableFeatures(object = query)),
  dims = 1:50,
  verbose = F
)

celltype.predictions <- TransferData(
  dims = 1:50,
  anchorset = anchors,
  refdata = reference$CellType,
  weight.reduction = query$pca,
  verbose = F
)


# Calculate mapping score and add to metadata
query <- AddMetaData(
  object = query,
  metadata = celltype.predictions
)

return(query)

}

