#!/usr/bin/env bash

mkdir -p ../output/Exp/transcriptome/tensor/GeneClassification/Mm

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Stim2Cell3Matrix.rds \
../output/Exp/transcriptome/tensor/GeneClassification/L1List_Stim.txt \
../input/PatternList.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Score.rds \
< Exp/transcriptome/tensor/GeneClassification/Mm/CalcScore.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Stim2Cell3Matrix.rds \
../output/Exp/transcriptome/tensor/GeneClassification/L1List_Stim.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/CheckQuantile.rds \
< Exp/transcriptome/tensor/GeneClassification/Mm/CheckQuantile.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Stim2Cell3Matrix.rds \
../output/Exp/transcriptome/tensor/GeneClassification/L1List_Stim.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Score.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/CheckQuantile.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Specificity.txt \
< Exp/transcriptome/tensor/GeneClassification/Mm/ReturnSpecificity.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/Stim2Cell3Matrix.rds \
../output/Exp/transcriptome/tensor/GeneClassification/L1List.txt \
../output/Exp/transcriptome/tensor/GeneClassification/L1List_Stim.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Specificity.txt \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Specificity.pdf \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Specificity.rds \
< Exp/transcriptome/tensor/GeneClassification/Mm/ExpHeatmap_Specificity.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Specificity.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Heatmap_SixCellType.pdf \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Specificity_sort.rds \
< Exp/transcriptome/tensor/GeneClassification/Mm/Heatmap_SixCellType.R




