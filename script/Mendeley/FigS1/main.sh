#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Mendeley/FigS1

R --vanilla --slave --args \
../output/Exp/Seurat/Seurat_raw/ \
../output/Exp/Seurat/Seurat_raw_fil/ \
../output/Exp/Seurat/AzimuthForFilter/ \
../output/Mendeley/FigS1/FigS1DEFG.txt \
< Mendeley/FigS1/FigS1DEFG.R


