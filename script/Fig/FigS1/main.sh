#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Fig/FigS1


R --vanilla --slave --args \
../input/experiments/FC/ \
../output/Fig/FigS1/FigS1A.pdf \
< Fig/FigS1/FigS1A.R

R --vanilla --slave --args \
../input/experiments/ViralRNA/ \
../output/Fig/FigS1/FigS1B.pdf \
< Fig/FigS1/FigS1B.R

R --vanilla --slave --args \
../input/experiments/ViralRNA/ \
../output/Fig/FigS1/FigS1C.pdf \
< Fig/FigS1/FigS1C.R

R --vanilla --slave --args \
../output/Exp/Seurat/Seurat_raw/Homo_sapiens_Mock_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Homo_sapiens_HSV1_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Homo_sapiens_SeV_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Homo_sapiens_LPS_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Pan_troglodytes_Mock_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Pan_troglodytes_HSV1_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Pan_troglodytes_SeV_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Pan_troglodytes_LPS_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Macaca_mulatta_Mock_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Macaca_mulatta_HSV1_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Macaca_mulatta_SeV_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Macaca_mulatta_LPS_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Rousettus_aegyptiacus_Mock_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Rousettus_aegyptiacus_HSV1_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Rousettus_aegyptiacus_SeV_metadata.rds \
../output/Exp/Seurat/Seurat_raw/Rousettus_aegyptiacus_LPS_metadata.rds \
../output/Fig/FigS1/FigS1DE.pdf \
< Fig/FigS1/FigS1DEFG.R


R --vanilla --slave --args \
../output/Exp/Seurat/Seurat_raw_fil/Homo_sapiens_Mock_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Homo_sapiens_HSV1_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Homo_sapiens_SeV_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Homo_sapiens_LPS_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Pan_troglodytes_Mock_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Pan_troglodytes_HSV1_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Pan_troglodytes_SeV_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Pan_troglodytes_LPS_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Macaca_mulatta_Mock_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Macaca_mulatta_HSV1_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Macaca_mulatta_SeV_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Macaca_mulatta_LPS_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Rousettus_aegyptiacus_Mock_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Rousettus_aegyptiacus_HSV1_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Rousettus_aegyptiacus_SeV_metadata.rds \
../output/Exp/Seurat/Seurat_raw_fil/Rousettus_aegyptiacus_LPS_metadata.rds \
../output/Fig/FigS1/FigS1FG.pdf \
< Fig/FigS1/FigS1DEFG.R



