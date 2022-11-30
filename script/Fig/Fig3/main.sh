#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Fig/Fig3

R --vanilla --slave --args \
../output/Exp/transcriptome/IFNresponse/GSVA_ISG.rds \
../output/Fig/Fig3/Fig3A.pdf \
< Fig/Fig3/Fig3A.R

R --vanilla --slave --args \
../output/Exp/transcriptome/IFNresponse/SensorsInfo.txt \
../output/Exp/transcriptome/IFNresponse/ \
../output/Fig/Fig3/Fig3B.pdf \
< Fig/Fig3/Fig3B.R


