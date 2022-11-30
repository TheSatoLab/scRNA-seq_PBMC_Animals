#!/usr/bin/env bash

mkdir -p ../output/Exp/transcriptome/tensor/RaSpecific

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Common/Specificity_sort.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Ra/Specificity_sort.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Mm/Specificity_sort.rds \
../output/Exp/transcriptome/tensor/RaSpecific/PatternCRM.txt \
< Exp/transcriptome/tensor/RaSpecific/PatternSort.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/RaSpecific/PatternCRM.txt \
../output/Exp/transcriptome/tensor/RaSpecific/Heatmap_CRM.pdf \
< Exp/transcriptome/tensor/RaSpecific/Heatmap_CRM.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/InputMatrix.rds \
../output/Exp/transcriptome/Overview/InputMatrixMetadata.rds \
../output/Exp/transcriptome/tensor/RaSpecific/PatternCRM.txt \
../input/mammalianCoreISG.txt \
../output/Exp/transcriptome/tensor/RaSpecific/Heatmap_RaISG.pdf \
< Exp/transcriptome/tensor/RaSpecific/Heatmap_RaISG.R

R --vanilla --slave --args \
../output/Exp/transcriptome/Overview/SixCellTypeMean.rds \
../output/Exp/transcriptome/tensor/RaSpecific/PatternCRM.txt \
../output/Exp/transcriptome/tensor/RaSpecific/Exp.rds \
../output/Exp/transcriptome/tensor/RaSpecific/metadata.rds \
< Exp/transcriptome/tensor/RaSpecific/GetALLhighExp.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/RaSpecific/Exp.rds \
../output/Exp/transcriptome/tensor/RaSpecific/metadata.rds \
../output/Exp/transcriptome/tensor/RaSpecific/Heatmap_StimExp.pdf \
< Exp/transcriptome/tensor/RaSpecific/Heatmap_StimExp.R


