#!/usr/bin/env bash

mkdir -p ../output/Exp/transcriptome/CellSubset/RaMono
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405


mkdir -p ../output/Exp/transcriptome/CellSubset/RaMono/Seurat
ls ../output/genome | xargs -n 1 -P 4 bash -c \
'
Species=${0}

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_integrated.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_SCT.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/${Species}.rds \
< Exp/transcriptome/CellSubset/RaMono/Clustering.R
'

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/Rousettus_aegyptiacus.rds \
../output/Exp/transcriptome/CellSubset/RaMono/DEG.rds \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil.txt \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil_down.txt \
< Exp/transcriptome/CellSubset/RaMono/CalcDEG.R

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/Rousettus_aegyptiacus.rds \
../output/Exp/transcriptome/CellSubset/RaMono/CellRatio.pdf \
< Exp/transcriptome/CellSubset/RaMono/CellNumber.R


bash Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/main.sh
bash Exp/transcriptome/CellSubset/RaMono/Features/main.sh



