#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Mendeley/Fig1

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/Homo_sapiens/Homo_sapiens.rds \
../output/Exp/Seurat/Merge/Homo_sapiens/Homo_sapiens_metadata.rds \
../output/Exp/Seurat/Merge/Pan_troglodytes/Pan_troglodytes.rds \
../output/Exp/Seurat/Merge/Pan_troglodytes/Pan_troglodytes_metadata.rds \
../output/Exp/Seurat/Merge/Macaca_mulatta/Macaca_mulatta.rds \
../output/Exp/Seurat/Merge/Macaca_mulatta/Macaca_mulatta_metadata.rds \
../output/Exp/Seurat/Merge/Rousettus_aegyptiacus/Rousettus_aegyptiacus.rds \
../output/Exp/Seurat/Merge/Rousettus_aegyptiacus/Rousettus_aegyptiacus_metadata.rds \
../output/Exp/Seurat/Mock/Merge_Mock.rds \
../output/Mendeley/Fig1/Fig1BS2ABDE.txt \
< Mendeley/Fig1/Fig1BS2ABDE.R


R --vanilla --slave --args \
../output/Exp/CellLabel/FourSpecies/CellRatio.txt \
../output/Mendeley/Fig1/Fig1D.txt \
< Mendeley/Fig1/Fig1D.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.txt \
../output/Mendeley/Fig1/Fig1E.txt \
< Mendeley/Fig1/Fig1E.R


