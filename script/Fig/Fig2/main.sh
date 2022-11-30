#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Fig/Fig2

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Fig/Fig2/Fig2B.pdf \
< Fig/Fig2/Fig2B.R


R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity_sort.rds \
../output/Fig/Fig2/Fig2D.pdf \
< Fig/Fig2/Fig2D.R


R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/RaSpecific/PatternCRM.txt \
../output/Fig/Fig2/Fig2F.pdf \
< Fig/Fig2/Fig2F.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/RaSpecific/Exp.rds \
../output/Exp/transcriptome/tensor/RaSpecific/metadata.rds \
../output/Fig/Fig2/Fig2G.pdf \
< Fig/Fig2/Fig2G.R





