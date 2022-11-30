#!/usr/bin/env bash

mkdir -p ../output/Exp/transcriptome/CellSubset/RaMono/CheckSpecificity
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/metadata
ls ../output/genome/ | xargs -n 1 -P 4 bash -c \
'
Species=${0}
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/${Species}.rds \
${Species} \
../output/ortholog/Hs_orthologs.txt \
../output/Exp/transcriptome/CellSubset/RaMono/DEG_fil.txt \
../output/Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/metadata/${Species}.rds \
< Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/CalcModuleScore.R
'

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/ \
../output/Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/metadata/ \
../output/Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/UMAP.pdf \
< Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/UMAP.R

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/RaMono/Seurat/ \
../output/Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/metadata/ \
../output/Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/UMAP_MockStim.pdf \
< Exp/transcriptome/CellSubset/RaMono/CheckSpecificity/UMAP_MockStim.R


