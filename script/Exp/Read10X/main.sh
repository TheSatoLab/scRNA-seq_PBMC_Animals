#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Exp/Seurat/Seurat_raw
tail -n +2 ../input/SampleInfo.txt | xargs -n 3 -P 16 bash -c \
'
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

Species=${1}
Stim=${2}
R --vanilla --slave --args \
../output/CellRanger/${Stim}/${Species}_${Stim}/outs/filtered_feature_bc_matrix.h5 \
${Species}_${Stim} \
../output/Exp/Seurat/Seurat_raw/${Species}_${Stim}.rds \
../output/Exp/Seurat/Seurat_raw/${Species}_${Stim}_metadata.rds \
< Exp/Read10X/ReadCountMatrix.R

mkdir -p ../output/Exp/Seurat/Seurat_raw_ortho
R --slave --vanilla --args \
${Species} \
${Stim} \
../output/Exp/Seurat/Seurat_raw/${Species}_${Stim}.rds \
../output/ortholog/Hs_orthologs.txt \
../output/Exp/Seurat/Seurat_raw_ortho/${Species}_${Stim}.rds \
< Exp/Read10X/GeneConvert.R

mkdir -p ../output/Exp/Seurat/AzimuthForFilter
R --slave --vanilla --args \
${Species} \
../output/Exp/AzimuthReference.rds \
../output/Exp/Seurat/Seurat_raw/${Species}_${Stim}.rds \
../output/Exp/Seurat/Seurat_raw_ortho/${Species}_${Stim}.rds \
../output/Exp/Seurat/AzimuthForFilter/${Species}_${Stim}.rds \
../output/Exp/Seurat/AzimuthForFilter/${Species}_${Stim}_metadata.rds \
< Exp/Read10X/azimuth_analysis.R

mkdir -p ../output/Exp/Seurat/Seurat_raw_fil
R --vanilla --slave --args \
../output/Exp/Seurat/Seurat_raw/${Species}_${Stim}.rds \
../output/Exp/Seurat/AzimuthForFilter/${Species}_${Stim}_metadata.rds \
${Stim} \
../output/Exp/Seurat/Seurat_raw_fil/${Species}_${Stim}.rds \
../output/Exp/Seurat/Seurat_raw_fil/${Species}_${Stim}_metadata.rds \
< Exp/Read10X/FeatureCountFilter.R

mkdir -p ../output/Exp/Seurat/Seurat_fil_ortho
R --slave --vanilla --args \
${Species} \
${Stim} \
../output/Exp/Seurat/Seurat_raw_fil/${Species}_${Stim}.rds \
../output/ortholog/Hs_orthologs.txt \
../output/Exp/Seurat/Seurat_fil_ortho/${Species}_${Stim}.rds \
< Exp/Read10X/GeneConvert.R
'

###QC_Check
mkdir -p ../output/Exp/QCinfo
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
../output/Exp/QCinfo/Before_QCinfo.pdf \
< Exp/Read10X/PlotnFeatureCountAll.R


mkdir -p ../output/Exp/QCinfo/Before/nFeature
mkdir -p ../output/Exp/QCinfo/Before/nCount
tail -n +2 ../input/SampleInfo.txt | xargs -n 3 -P 16 bash -c \
'
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

Species=${1}
Stim=${2}
R --vanilla --slave --args \
../output/Exp/Seurat/Seurat_raw/${Species}_${Stim}.rds \
../output/Exp/QCinfo/Before/nFeature/${Species}_${Stim}_nFeature_RNA.pdf \
../output/Exp/QCinfo/Before/nCount/${Species}_${Stim}_nCount_RNA.pdf \
< Exp/Read10X/PlotnFeatureCountEach.R
'

mkdir -p ../output/Exp/QCinfo/PlotCheck
tail -n +2 ../input/SampleInfo.txt | xargs -n 3 -P 16 bash -c \
'
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

Species=${1}
Stim=${2}
R --slave --vanilla --args \
../output/Exp/AzimuthReference.rds \
../output/Exp/Seurat/AzimuthForFilter/${Species}_${Stim}.rds \
../output/Exp/QCinfo/PlotCheck/${Species}_${Stim}.pdf \
< Exp/Read10X/azimuth_analysis_PlotCheck.R
'

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
../output/Exp/QCinfo/After_QCinfo.pdf \
< Exp/Read10X/PlotnFeatureCountAll.R


