#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Exp/CellLabel/FourSpecies/pdf

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/Homo_sapiens/Homo_sapiens.rds \
../output/Exp/Seurat/Merge/Homo_sapiens/Homo_sapiens_metadata.rds \
../output/Exp/Seurat/Merge/Pan_troglodytes/Pan_troglodytes.rds \
../output/Exp/Seurat/Merge/Pan_troglodytes/Pan_troglodytes_metadata.rds \
../output/Exp/Seurat/Merge/Macaca_mulatta/Macaca_mulatta.rds \
../output/Exp/Seurat/Merge/Macaca_mulatta/Macaca_mulatta_metadata.rds \
../output/Exp/Seurat/Merge/Rousettus_aegyptiacus/Rousettus_aegyptiacus.rds \
../output/Exp/Seurat/Merge/Rousettus_aegyptiacus/Rousettus_aegyptiacus_metadata.rds \
../output/Exp/CellLabel/FourSpecies/pdf/UMAP_Label.pdf \
../output/Exp/CellLabel/FourSpecies/pdf/UMAP_Label_11CellType.pdf \
< Exp/CellLabel/FourSpecies/Labeling.R

R --vanilla --slave --args \
../output/Exp/CellLabel/Homo_sapiens/CellRatio.txt \
../output/Exp/CellLabel/Pan_troglodytes/CellRatio.txt \
../output/Exp/CellLabel/Macaca_mulatta/CellRatio.txt \
../output/Exp/CellLabel/Rousettus_aegyptiacus/CellRatio.txt \
../output/Exp/CellLabel/FourSpecies/CellRatio.txt \
../output/Exp/CellLabel/FourSpecies/pdf/CellRatio.pdf \
< Exp/CellLabel/FourSpecies/CellRatio.R

R --vanilla --slave --args \
../output/Exp/CellLabel/FourSpecies/CellRatio.txt \
../output/Exp/CellLabel/FourSpecies/pdf/CellRatio_fil.pdf \
< Exp/CellLabel/FourSpecies/CellRatio_fil.R

mkdir -p ../output/Exp/CellLabel/FourSpecies/pdf/DotPlot
mkdir -p ../output/Exp/CellLabel/FourSpecies/pdf/DotPlot_fil
ls ../output/genome/ | xargs -n 1 -P 4 bash -c \
'
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

Species=${0}
R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
< Exp/CellLabel/FourSpecies/AddCoreCellType.R

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_SCT.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
${Species} \
../output/ortholog/Hs_orthologs.txt \
../output/Exp/CellLabel/${Species}/pdf/DotPlot_Label.pdf \
../output/Exp/CellLabel/FourSpecies/pdf/DotPlot/DotPlot_Label_${Species}.pdf \
< Exp/CellLabel/FourSpecies/DotPlot_Label.R
'

