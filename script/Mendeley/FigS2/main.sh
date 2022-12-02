#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Mendeley/FigS2

ls ../output/genome/ | xargs -n 1 -P 4 bash -c \
'
Species=${0}
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405
mkdir -p ../output/Exp/Seurat/Merge/${Species}

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
../output/Mendeley/FigS2/FigS2C_${Species}.txt \
< Mendeley/FigS2/FigS2C.R
'

R --vanilla --slave --args \
../output/Exp/Seurat/Mock/Merge_Mock.rds \
../output/Mendeley/FigS2/FigS2F.txt \
< Mendeley/FigS2/FigS2F.R






R --slave --vanilla --args \
../output/Exp/Seurat/Mock/Merge_Mock.rds \
../output/Exp/Seurat/Merge/Homo_sapiens/Homo_sapiens_metadata.rds \
../output/Exp/Seurat/Merge/Pan_troglodytes/Pan_troglodytes_metadata.rds \
../output/Exp/Seurat/Merge/Macaca_mulatta/Macaca_mulatta_metadata.rds \
../output/Exp/Seurat/Merge/Rousettus_aegyptiacus/Rousettus_aegyptiacus_metadata.rds \
../output/Fig/FigS2/FigS2E.pdf \
< Fig/FigS2/FigS2E.R


ls ../output/genome/ | xargs -n 1 -P 4 bash -c \
'
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

Species=${0}
R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_SCT.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
${Species} \
../output/ortholog/Hs_orthologs.txt \
../output/Fig/FigS2/FigS2G_${Species}.pdf \
< Fig/FigS2/FigS2G.R
'

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/CellTypeMean.rds \
../output/Fig/FigS2/FigS2H.pdf \
< Fig/FigS2/FigS2H.R

