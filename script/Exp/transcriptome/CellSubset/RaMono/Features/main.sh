#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Exp/transcriptome/CellSubset/RaMono/Features

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/Rousettus_aegyptiacus.rds \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil.txt \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil_down.txt \
../output/Exp/transcriptome/CellSubset/RaMono/Features/Heatmap_DEG5.pdf \
../output/Exp/transcriptome/CellSubset/RaMono/Features/Heatmap_DEG7.pdf \
< Exp/transcriptome/CellSubset/RaMono/Features/MarkerHeatmap.R


mkdir -p ../output/Exp/transcriptome/CellSubset/RaMono/Features/GO
mkdir -p ../output/Exp/transcriptome/CellSubset/RaMono/Features/GOfil
R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/DEG.rds \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil.txt \
../input/GO/c5.go.bp.v7.3.rds \
../input/GO/c2.cp.v7.3.rds \
../output/ortholog/Hs_orthologs.txt \
../output/Exp/transcriptome/CellSubset/RaMono/Features/GO/ \
../output/Exp/transcriptome/CellSubset/RaMono/Features/GOfil/ \
< Exp/transcriptome/CellSubset/RaMono/Features/Odds_BPCP.R

mkdir -p ../output/Exp/transcriptome/CellSubset/RaMono/Features/GO_down
mkdir -p ../output/Exp/transcriptome/CellSubset/RaMono/Features/GO_downfil
R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/DEG.rds \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil_down.txt \
../input/GO/c5.go.bp.v7.3.rds \
../input/GO/c2.cp.v7.3.rds \
../output/ortholog/Hs_orthologs.txt \
../output/Exp/transcriptome/CellSubset/RaMono/Features/GO_down/ \
../output/Exp/transcriptome/CellSubset/RaMono/Features/GO_downfil/ \
< Exp/transcriptome/CellSubset/RaMono/Features/Odds_BPCP.R


R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Features/GOfil/C5.txt \
../output/Exp/transcriptome/CellSubset/RaMono/Features/GOfil/C7.txt \
../output/Exp/transcriptome/CellSubset/RaMono/Features/GO_downfil/C5.txt \
../output/Exp/transcriptome/CellSubset/RaMono/Features/GO_downfil/C7.txt \
../output/Exp/transcriptome/CellSubset/RaMono/Features/GOBPCP_barplot.pdf \
< Exp/transcriptome/CellSubset/RaMono/Features/DEGS_barplot.R





