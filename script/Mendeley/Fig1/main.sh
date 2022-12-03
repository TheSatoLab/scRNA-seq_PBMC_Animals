#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Mendeley/Fig1

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/ \
../output/Mendeley/Fig1/Fig1B.txt \
< Mendeley/Fig1/Fig1B.R

R --vanilla --slave --args \
../output/Exp/CellLabel/FourSpecies/CellRatio.txt \
../output/Mendeley/Fig1/Fig1D.txt \
< Mendeley/Fig1/Fig1D.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.txt \
../output/Mendeley/Fig1/Fig1E.txt \
< Mendeley/Fig1/Fig1E.R





