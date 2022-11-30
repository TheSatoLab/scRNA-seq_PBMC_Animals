#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

Dir=CellLabel
Stim=Mock

mkdir -p ../output/Exp/Seurat/${Stim}
mkdir -p ../output/Exp/${Dir}/${Stim}/pdf

R --slave --vanilla --args \
../output/Exp/Seurat/Seurat_raw_fil/Homo_sapiens_Mock.rds \
../output/Exp/Seurat/Seurat_fil_ortho/Pan_troglodytes_Mock.rds \
../output/Exp/Seurat/Seurat_fil_ortho/Macaca_mulatta_Mock.rds \
../output/Exp/Seurat/Seurat_fil_ortho/Rousettus_aegyptiacus_Mock.rds \
../output/Exp/Seurat/${Stim}/Merge_${Stim}.rds \
< Exp/${Dir}/MockIntegration/Merge.R

R --vanilla --slave --args \
../output/Exp/Seurat/${Stim}/Merge_${Stim}.rds \
../output/Exp/${Dir}/${Stim}/pdf/UMAP.pdf \
../output/Exp/${Dir}/${Stim}/pdf/Dist.pdf \
< Exp/${Dir}/MockIntegration/Clustering.R

R --slave --vanilla --args \
../output/Exp/Seurat/${Stim}/Merge_${Stim}.rds \
../output/Exp/Seurat/Merge/Homo_sapiens/Homo_sapiens_metadata.rds \
../output/Exp/Seurat/Merge/Pan_troglodytes/Pan_troglodytes_metadata.rds \
../output/Exp/Seurat/Merge/Macaca_mulatta/Macaca_mulatta_metadata.rds \
../output/Exp/Seurat/Merge/Rousettus_aegyptiacus/Rousettus_aegyptiacus_metadata.rds \
../output/Exp/${Dir}/${Stim}/pdf/Merge_UMAP.pdf \
../output/Exp/Seurat/${Stim}/Merge_${Stim}_metadata.rds \
< Exp/${Dir}/MockIntegration/mtMerge.R


