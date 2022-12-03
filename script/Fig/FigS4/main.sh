#!/usr/bin/env bash

mkdir -p ../output/Fig/FigS4

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/CheckAllCellType/UMAP_data/ \
../output/Fig/FigS4/FigS4A.pdf \
< Fig/FigS4/FigS4A.R

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/ \
../output/Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/metadata/ \
../output/Fig/FigS4/FigS4B.pdf \
< Fig/FigS4/FigS4B.R



