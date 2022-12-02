#!/usr/bin/env bash

mkdir -p ../output/Mendeley/Fig4

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/ \
../output/Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/metadata/ \
../output/Mendeley/Fig4/Fig4ABC.txt \
< Mendeley/Fig4/Fig4ABC.R

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/Rousettus_aegyptiacus.rds \
../output/Mendeley/Fig4/Fig4D.txt \
< Mendeley/Fig4/Fig4D.R

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/Rousettus_aegyptiacus.rds \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil.txt \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil_down.txt \
5 \
../output/Mendeley/Fig4/Fig4E.txt \
< Mendeley/Fig4/Fig4EG.R

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Features/GOfil/C5.txt \
../output/Exp/transcriptome/CellSubset/RaMono/Features/GO_downfil/C5.txt \
../output/Mendeley/Fig4/Fig4F.txt \
< Mendeley/Fig4/Fig4FH.R

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/Rousettus_aegyptiacus.rds \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil.txt \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil_down.txt \
7 \
../output/Mendeley/Fig4/Fig4G.txt \
< Mendeley/Fig4/Fig4EG.R

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Features/GOfil/C7.txt \
../output/Exp/transcriptome/CellSubset/RaMono/Features/GO_downfil/C7.txt \
../output/Mendeley/Fig4/Fig4H.txt \
< Mendeley/Fig4/Fig4FH.R







