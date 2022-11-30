#!/usr/bin/env bash

mkdir -p ../output/Exp/transcriptome/IFNresponse
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/ortholog/Hs_orthologs.txt \
../output/Exp/Seurat/Merge/ \
../input/mammalianCoreISG.txt \
../output/Exp/transcriptome/IFNresponse/GSVA_ISG.rds \
< Exp/transcriptome/IFNresponse/CalcModuleScore.R

R --vanilla --slave --args \
../output/Exp/transcriptome/IFNresponse/GSVA_ISG.rds \
../output/Exp/transcriptome/IFNresponse/Boxplot_ISG.pdf \
< Exp/transcriptome/IFNresponse/Boxplot_ISG.R

R --vanilla --slave --args \
../input/Sensors.txt \
../output/ortholog/Hs_orthologs.txt \
../output/Exp/transcriptome/IFNresponse/SensorsInfo.txt \
< Exp/transcriptome/IFNresponse/SensorGenes_ortholog.R

ls ../output/genome | xargs -n 1 -P 4 bash -c \
'
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405
Species=${0}
R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}_SCT.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
../output/Exp/transcriptome/IFNresponse/SensorsInfo.txt \
${Species} \
../output/Exp/transcriptome/IFNresponse/${Species}_metadata_SensorGenes.rds \
< Exp/transcriptome/IFNresponse/SensorGenes.R
'

R --vanilla --slave --args \
../output/Exp/transcriptome/IFNresponse/SensorsInfo.txt \
../output/Exp/transcriptome/IFNresponse/ \
../output/Exp/transcriptome/IFNresponse/Heatmap_SensorGenes.pdf \
< Exp/transcriptome/IFNresponse/Heatmap_SensorGenes.R

R --vanilla --slave --args \
../output/Exp/transcriptome/IFNresponse/SensorsInfo.txt \
../output/Exp/transcriptome/IFNresponse/ \
../output/Exp/transcriptome/IFNresponse/Heatmap_SensorGenes_Mock.pdf \
< Exp/transcriptome/IFNresponse/Heatmap_SensorGenes_Mock.R

R --vanilla --slave --args \
../output/Exp/transcriptome/IFNresponse/ \
../output/Exp/transcriptome/IFNresponse/TLR3_violin.pdf \
< Exp/transcriptome/IFNresponse/TLR3_violin.R



