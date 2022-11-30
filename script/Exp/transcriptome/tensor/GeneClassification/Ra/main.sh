#!/usr/bin/env bash

mkdir -p ../output/Exp/transcriptome/tensor/GeneClassification/Ra

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Stim2Cell3Matrix.rds \
../output/Exp/transcriptome/tensor/GeneClassification/L1List_Stim.txt \
../input/PatternList.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Score.rds \
< Exp/transcriptome/tensor/GeneClassification/Ra/CalcScore.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Stim2Cell3Matrix.rds \
../output/Exp/transcriptome/tensor/GeneClassification/L1List_Stim.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/CheckQuantile.rds \
< Exp/transcriptome/tensor/GeneClassification/Ra/CheckQuantile.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Stim2Cell3Matrix.rds \
../output/Exp/transcriptome/tensor/GeneClassification/L1List_Stim.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Score.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/CheckQuantile.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity.txt \
< Exp/transcriptome/tensor/GeneClassification/Ra/ReturnSpecificity.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Stim2Cell3Matrix.rds \
../output/Exp/transcriptome/tensor/GeneClassification/L1List.txt \
../output/Exp/transcriptome/tensor/GeneClassification/L1List_Stim.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity.pdf \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity.rds \
< Exp/transcriptome/tensor/GeneClassification/Ra/ExpHeatmap_Specificity.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Heatmap_SixCellType.pdf \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity_sort.rds \
< Exp/transcriptome/tensor/GeneClassification/Ra/Heatmap_SixCellType.R

bash Exp/transcriptome/tensor/GeneClassification/Ra/GO/main.sh

