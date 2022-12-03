#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Mendeley/Fig1S1S2

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/ \
../output/Exp/Seurat/Mock/Merge_Mock.rds \
../output/Mendeley/Fig1S1S2/Fig1BS2ABDE.txt \
< Mendeley/Fig1S1S2/Fig1BS2ABDE.R

R --vanilla --slave --args \
../output/Exp/CellLabel/FourSpecies/CellRatio.txt \
../output/Mendeley/Fig1S1S2/Fig1D.txt \
< Mendeley/Fig1S1S2/Fig1D.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.txt \
../output/Mendeley/Fig1S1S2/Fig1E.txt \
< Mendeley/Fig1S1S2/Fig1E.R


R --vanilla --slave --args \
../output/Exp/Seurat/Seurat_raw/ \
../output/Exp/Seurat/Seurat_raw_fil/ \
../output/Mendeley/Fig1S1S2/FigS1DEFG.txt \
< Mendeley/Fig1S1S2/FigS1DEFG.R

ls ../output/genome/ | xargs -n 1 -P 4 bash -c \
'
Species=${0}
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
../output/Mendeley/Fig1S1S2/FigS2C_${Species}.txt \
< Mendeley/Fig1S1S2/FigS2C.R
'

R --vanilla --slave --args \
../output/Exp/Seurat/Mock/Merge_Mock.rds \
../output/Mendeley/Fig1S1S2/FigS2F.txt \
< Mendeley/Fig1S1S2/FigS2F.R

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/ \
../output/ortholog/Hs_orthologs.txt \
../output/Mendeley/Fig1S1S2/FigS2G.txt \
< Mendeley/Fig1S1S2/FigS2G.R


R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/CellTypeMean.rds \
../output/Mendeley/Fig1S1S2/FigS2H.txt \
< Mendeley/Fig1S1S2/FigS2H.R



