#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Mendeley/Fig2S3

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Mendeley/Fig2S3/Fig2B.txt \
< Mendeley/Fig2S3/Fig2B.R


R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity_sort.rds \
../output/Mendeley/Fig2S3/Fig2D.txt \
< Mendeley/Fig2S3/Fig2D.R


R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/RaSpecific/PatternCRM.txt \
../output/Mendeley/Fig2S3/Fig2F.txt \
< Mendeley/Fig2S3/Fig2F.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/RaSpecific/Exp.rds \
../output/Exp/transcriptome/tensor/RaSpecific/metadata.rds \
../output/Mendeley/Fig2S3/Fig2G.txt \
< Mendeley/Fig2S3/Fig2G.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Mendeley/Fig2S3/FigS3A.txt \
< Mendeley/Fig2S3/FigS3A.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Mendeley/Fig2S3/FigS3B.txt \
< Mendeley/Fig2S3/FigS3B.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Specificity_sort.rds \
../output/Mendeley/Fig2S3/FigS3GJ.txt \
< Mendeley/Fig2S3/FigS3GJ.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity_sort.rds \
../output/Mendeley/Fig2S3/FigS3HK.txt \
< Mendeley/Fig2S3/FigS3HK.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Specificity_sort.rds \
../output/Mendeley/Fig2S3/FigS3IL.txt \
< Mendeley/Fig2S3/FigS3IL.R





