#!/usr/bin/env bash

ls ../output/genome/ | xargs -n 1 -P 4 bash -c \
'
Species=${0}
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/CellLabel/${Species}/ClusterPrediction_Mockmax.txt \
../output/Exp/CellLabel/${Species}/ClusterPrediction_Mockmod.txt \
< Exp/CellLabel/LabelDecision/LabelMod/${Species}.R

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
../output/Exp/CellLabel/${Species}/ClusterPrediction_Mockmod.txt \
../output/Exp/CellLabel/${Species}/pdf/UMAP_Label.pdf \
< Exp/CellLabel/LabelDecision/Labeling.R

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
../output/Exp/CellLabel/${Species}/CellRatio.txt \
../output/Exp/CellLabel/${Species}/pdf/CellRatio.pdf \
< Exp/CellLabel/LabelDecision/CellRatio.R

R --slave --vanilla --args \
../output/Exp/Seurat/Azimuth/${Species}_Mock_coarse.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
../output/Exp/CellLabel/${Species}/pdf/PredictionScore.pdf \
< Exp/CellLabel/LabelDecision/PredictionScorePlot.R

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_SCT.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
${Species} \
../output/ortholog/Hs_orthologs.txt \
../output/Exp/CellLabel/${Species}/pdf/DotPlot_SpeciesLabel.pdf \
< Exp/CellLabel/LabelDecision/DotPlot_SpeciesLabel.R

'




