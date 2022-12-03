#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Mendeley/Fig2

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Mendeley/Fig2/Fig2B.txt \
< Mendeley/Fig2/Fig2B.R


R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity_sort.rds \
../output/Mendeley/Fig2/Fig2D.txt \
< Mendeley/Fig2/Fig2D.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/GO/GOCP/GO10/ \
../output/Mendeley/Fig2/Fig2E.txt \
< Mendeley/Fig2/Fig2E.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/RaSpecific/PatternCRM.txt \
../output/Mendeley/Fig2/Fig2F.txt \
< Mendeley/Fig2/Fig2F.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/RaSpecific/Exp.rds \
../output/Exp/transcriptome/tensor/RaSpecific/metadata.rds \
../output/Mendeley/Fig2/Fig2G.txt \
< Mendeley/Fig2/Fig2G.R



