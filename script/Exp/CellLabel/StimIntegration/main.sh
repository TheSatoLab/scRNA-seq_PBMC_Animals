#!/usr/bin/env bash

ls ../output/genome/ | xargs -n 1 -P 4 bash -c \
'
Species=${0}
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405
mkdir -p ../output/Exp/Seurat/Merge/${Species}

R --vanilla --slave --args \
../output/Exp/Seurat/Seurat_raw_fil/${Species}_Mock.rds \
../output/Exp/Seurat/Seurat_raw_fil/${Species}_HSV1.rds \
../output/Exp/Seurat/Seurat_raw_fil/${Species}_SeV.rds \
../output/Exp/Seurat/Seurat_raw_fil/${Species}_LPS.rds \
${Species} \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata_base.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_RNA.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_SCT.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_integrated.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}.rds \
< Exp/CellLabel/StimIntegration/Merge.R

mkdir -p ../output/Exp/Seurat/Azimuth
mkdir -p ../output/Exp/CellLabel/${Species}/pdf
R --slave --vanilla --args \
../output/Exp/AzimuthReference.rds \
${Species} \
../output/Exp/Seurat/Seurat_raw_fil/${Species}_Mock.rds \
../output/Exp/Seurat/Seurat_fil_ortho/${Species}_Mock.rds \
../output/Exp/Seurat/Azimuth/${Species}_Mock.rds \
../output/Exp/Seurat/Azimuth/${Species}_Mock_metadata.rds \
../output/Exp/CellLabel/${Species}/pdf/${Species}_Mock.pdf \
< Exp/CellLabel/StimIntegration/AzimuthMock.R

R --slave --vanilla --args \
../output/Exp/AzimuthReference.rds \
../input/AzimuthReferenceCelltypeInfo.txt \
${Species} \
../output/Exp/Seurat/Seurat_raw_fil/${Species}_Mock.rds \
../output/Exp/Seurat/Seurat_fil_ortho/${Species}_Mock.rds \
../output/Exp/Seurat/Azimuth/${Species}_Mock_coarse.rds \
../output/Exp/Seurat/Azimuth/${Species}_Mock_coarse_metadata.rds \
../output/Exp/CellLabel/${Species}/pdf/${Species}_Mock_coarse.pdf \
< Exp/CellLabel/StimIntegration/AzimuthMock_coarse.R

R --slave --vanilla --args \
../output/Exp/Seurat/Azimuth/${Species}_Mock_coarse_metadata.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata_base.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
< Exp/CellLabel/StimIntegration/AddPredictionInfo.R

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_integrated.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
../output/Exp/CellLabel/${Species}/pdf/UMAP_coarse.pdf \
../output/Exp/CellLabel/${Species}/pdf/Dist_coarse.pdf \
< Exp/CellLabel/StimIntegration/Clustering/${Species}.R

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_RNA.rds \
../output/Exp/Seurat/Azimuth/${Species}_Mock.rds \
../output/Exp/CellLabel/${Species}/pdf/UMAP.pdf \
< Exp/CellLabel/StimIntegration/UMAP.R

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
../output/Exp/CellLabel/${Species}/CellNumber_Mockraw.txt \
../output/Exp/CellLabel/${Species}/ClusterPrediction_Mockmax.txt \
< Exp/CellLabel/StimIntegration/CellNumber.R

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_SCT.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
${Species} \
../output/ortholog/Hs_orthologs.txt \
../output/Exp/CellLabel/${Species}/pdf/DotPlot_Cluster.pdf \
< Exp/CellLabel/StimIntegration/DotPlot.R


'

