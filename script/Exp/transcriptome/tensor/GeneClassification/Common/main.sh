#!/usr/bin/env bash

mkdir -p ../output/Exp/transcriptome/tensor/GeneClassification/Common

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Stim2Cell3Matrix.rds \
../output/Exp/transcriptome/tensor/GeneClassification/L1List_Stim.txt \
../input/PatternList.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Score.rds \
< Exp/transcriptome/tensor/GeneClassification/Common/CalcScore.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Stim2Cell3Matrix.rds \
../output/Exp/transcriptome/tensor/GeneClassification/L1List_Stim.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Common/CheckQuantile.rds \
< Exp/transcriptome/tensor/GeneClassification/Common/CheckQuantile.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Stim2Cell3Matrix.rds \
../output/Exp/transcriptome/tensor/GeneClassification/L1List_Stim.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Score.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Common/CheckQuantile.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Specificity.txt \
< Exp/transcriptome/tensor/GeneClassification/Common/ReturnSpecificity.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Stim2Cell3Matrix.rds \
../output/Exp/transcriptome/tensor/GeneClassification/L1List.txt \
../output/Exp/transcriptome/tensor/GeneClassification/L1List_Stim.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Specificity.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Specificity.pdf \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Specificity.rds \
< Exp/transcriptome/tensor/AGeneClassification/Common/ExpHeatmap_Specificity.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Specificity.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Heatmap_SixCellType.pdf \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Specificity_sort.rds \
< Exp/transcriptome/tensor/GeneClassification/Common/Heatmap_SixCellType.R



