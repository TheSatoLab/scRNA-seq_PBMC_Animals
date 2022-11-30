#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Fig/FigS3

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Fig/FigS3/FigS3A.pdf \
< Fig/FigS3/FigS3A.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Fig/FigS3/FigS3B.pdf \
< Fig/FigS3/FigS3B.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Specificity_sort.rds \
../output/Fig/FigS3/FigS3G.pdf \
< Fig/FigS3/FigS3G.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity_sort.rds \
../output/Fig/FigS3/FigS3H.pdf \
< Fig/FigS3/FigS3H.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Specificity_sort.rds \
../output/Fig/FigS3/FigS3I.pdf \
< Fig/FigS3/FigS3I.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Specificity_sort.rds \
../output/Fig/FigS3/FigS3J.pdf \
< Fig/FigS3/FigS3J.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity_sort.rds \
../output/Fig/FigS3/FigS3K.pdf \
< Fig/FigS3/FigS3K.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Specificity_sort.rds \
../output/Fig/FigS3/FigS3L.pdf \
< Fig/FigS3/FigS3L.R


