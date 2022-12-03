#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Mendeley/FigS3

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Mendeley/FigS3/FigS3A.txt \
< Mendeley/FigS3/FigS3A.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Mendeley/FigS3/FigS3B.txt \
< Mendeley/FigS3/FigS3B.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Specificity_sort.rds \
../output/Mendeley/FigS3/FigS3G.txt \
< Mendeley/FigS3/FigS3G.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity_sort.rds \
../output/Mendeley/FigS3/FigS3H.txt \
< Mendeley/FigS3/FigS3H.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Specificity_sort.rds \
../output/Mendeley/FigS3/FigS3I.txt \
< Mendeley/FigS3/FigS3I.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Specificity_sort.rds \
../output/Mendeley/FigS3/FigS3J.txt \
< Mendeley/FigS3/FigS3JKL.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity_sort.rds \
../output/Mendeley/FigS3/FigS3K.txt \
< Mendeley/FigS3/FigS3JKL.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Specificity_sort.rds \
../output/Mendeley/FigS3/FigS3L.txt \
< Mendeley/FigS3/FigS3JKL.R





