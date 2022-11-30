#!/usr/bin/env bash

mkdir -p ../output/Exp/transcriptome/tensor/GeneClassification/Ra/GO

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

###########################################################
###GOCP
mkdir -p ../output/Exp/transcriptome/tensor/GeneClassification/Ra/GO/GOCP
mkdir -p ../output/Exp/transcriptome/tensor/GeneClassification/Ra/GO/GOCP/GO10
mkdir -p ../output/Exp/transcriptome/tensor/GeneClassification/Ra/GO/GOCP/GO10fil
R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity.rds \
../input/GO/c2.cp.v7.3.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/GO/GOCP/GO10/ \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/GO/GOCP/GO10fil/ \
< Exp/transcriptome/tensor/GeneClassification/Ra/GO/Odds10.R

mkdir -p ../output/Exp/transcriptome/tensor/GeneClassification/Ra/GO/GOCP/GO18
mkdir -p ../output/Exp/transcriptome/tensor/GeneClassification/Ra/GO/GOCP/GO18fil
R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity.rds \
../input/GO/c2.cp.v7.3.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/GO/GOCP/GO18/ \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/GO/GOCP/GO18fil/ \
< Exp/transcriptome/tensor/GeneClassification/Ra/GO/Odds18.R




