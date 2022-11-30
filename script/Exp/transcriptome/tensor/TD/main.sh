#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate py38

mkdir -p ../output/Exp/transcriptome/tensor/TD/core
python Exp/transcriptome/tensor/TD/TD.py \
../output/Exp/transcriptome/tensor/Preprocess/InputTensor.npy \
../output/Exp/transcriptome/tensor/TD/TDres_A1.npy \
../output/Exp/transcriptome/tensor/TD/TDres_A2.npy \
../output/Exp/transcriptome/tensor/TD/TDres_A3.npy \
../output/Exp/transcriptome/tensor/TD/TDres_A4.npy \
../output/Exp/transcriptome/tensor/TD/core/ \
../output/Exp/transcriptome/tensor/TD/shelf


conda activate R405

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/FCZ.rds \
../output/Exp/transcriptome/tensor/TD/TDres_A1.npy \
../output/Exp/transcriptome/tensor/TD/TDres_A2.npy \
../output/Exp/transcriptome/tensor/TD/TDres_A3.npy \
../output/Exp/transcriptome/tensor/TD/TDres_A4.npy \
../output/Exp/transcriptome/tensor/TD/core/ \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Exp/transcriptome/tensor/Preprocess/InputTensor.rds \
< Exp/transcriptome/tensor/TD/MakeTDres.R

mkdir -p ../output/Exp/transcriptome/tensor/TD/pdf
R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Exp/transcriptome/tensor/TD/pdf/Heatmap_A1.pdf \
../output/Exp/transcriptome/tensor/TD/pdf/Heatmap_A2.pdf \
../output/Exp/transcriptome/tensor/TD/pdf/Heatmap_A3.pdf \
../output/Exp/transcriptome/tensor/TD/pdf/Heatmap_A4.pdf \
< Exp/transcriptome/tensor/TD/CheckA.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Exp/transcriptome/tensor/TD/lfInfo.txt \
< Exp/transcriptome/tensor/TD/MakeLfInfo.R



