#!/usr/bin/env bash

mkdir -p ../output/Fig/Fig4

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/ \
../output/Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/metadata/ \
../output/Fig/Fig4/Fig4ABC.pdf \
< Fig/Fig4/Fig4ABC.R

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/Rousettus_aegyptiacus.rds \
../output/Fig/Fig4/Fig4D.pdf \
< Fig/Fig4/Fig4D.R

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/Rousettus_aegyptiacus.rds \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil.txt \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil_down.txt \
5 \
../output/Fig/Fig4/Fig4E.pdf \
< Fig/Fig4/Fig4EG.R

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/Rousettus_aegyptiacus.rds \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil.txt \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil_down.txt \
7 \
../output/Fig/Fig4/Fig4G.pdf \
< Fig/Fig4/Fig4EG.R


