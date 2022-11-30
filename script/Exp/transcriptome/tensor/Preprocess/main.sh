#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Exp/transcriptome/tensor/Preprocess

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/FCZ.rds \
../output/Exp/transcriptome/tensor/Preprocess/InputTensor.rds \
< Exp/transcriptome/tensor/Preprocess/MakeTensor.R

mkdir -p ../output/Exp/transcriptome/tensor/Preprocess/data
R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/FCZ.rds \
../output/Exp/transcriptome/tensor/Preprocess/data/ \
< Exp/transcriptome/tensor/Preprocess/ExportToPython.R

conda activate py38
python Exp/transcriptome/tensor/Preprocess/MakeTensor.py \
../output/Exp/transcriptome/tensor/Preprocess/data/ \
../output/Exp/transcriptome/tensor/Preprocess/InputTensor.npy \




