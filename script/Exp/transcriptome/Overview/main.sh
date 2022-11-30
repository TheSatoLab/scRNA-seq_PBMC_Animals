#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Exp/transcriptome/Overview

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/ \
../output/ortholog/Hs_orthologs.txt \
../output/Exp/transcriptome/Overview/GeneList.rds \
../output/Exp/transcriptome/Overview/CellTypeMean.rds \
< Exp/transcriptome/Overview/CalcCellTypeMean.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/CellTypeMean.rds \
../output/Exp/transcriptome/Overview/Heatmap_PCA_AllCellType.pdf \
< Exp/transcriptome/Overview/Heatmap_PCA_AllCellType.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/CellTypeMean.rds \
../output/Exp/transcriptome/Overview/SixCellTypeMean.rds \
< Exp/transcriptome/Overview/CalcSixCellTypeMean.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/SixCellTypeMean.rds \
../output/Exp/transcriptome/Overview/GeneList.rds \
../output/Exp/transcriptome/Overview/FC.rds \
< Exp/transcriptome/Overview/CalcFC.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/FC.rds \
../output/Exp/transcriptome/Overview/FCZ.rds \
< Exp/transcriptome/Overview/FCtoZ.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/FCZ.rds \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.txt \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
< Exp/transcriptome/Overview/GenerateInputMatrix.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.txt \
../output/Exp/transcriptome/Overview/Heatmap_PCA_FC.pdf \
< Exp/transcriptome/Overview/Heatmap_PCA_FC.R






