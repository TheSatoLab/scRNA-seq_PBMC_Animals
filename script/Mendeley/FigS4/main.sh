#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Mendeley/FigS4

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/CheckAllCellType/UMAP_data/ \
../output/Mendeley/FigS4/FigS4A.txt \
< Mendeley/FigS4/FigS4A.R

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/ \
../output/Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/metadata/ \
../output/Mendeley/FigS4/FigS4B.txt \
< Mendeley/FigS4/FigS4B.R






