#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Mendeley/FigS2

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/ \
../output/Mendeley/FigS2/FigS2A.txt \
< Mendeley/FigS2/FigS2A.R

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/ \
../output/Mendeley/FigS2/FigS2B.txt \
< Mendeley/FigS2/FigS2B.R


ls ../output/genome/ | xargs -n 1 -P 4 bash -c \
'
Species=${0}
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
../output/Mendeley/FigS2/FigS2C_${Species}.txt \
< Mendeley/FigS2/FigS2C.R
'

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/ \
../output/Exp/Seurat/Mock/Merge_Mock.rds \
../output/Mendeley/FigS2/FigS2DE.txt \
< Mendeley/FigS2/FigS2DE.R

R --vanilla --slave --args \
../output/Exp/Seurat/Mock/Merge_Mock.rds \
../output/Mendeley/FigS2/FigS2F.txt \
< Mendeley/FigS2/FigS2F.R

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/ \
../output/ortholog/Hs_orthologs.txt \
../output/Mendeley/FigS2/FigS2G.txt \
< Mendeley/FigS2/FigS2G.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/CellTypeMean.rds \
../output/Mendeley/FigS2/FigS2H.txt \
< Mendeley/FigS2/FigS2H.R



