#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda create -n R405
conda activate R405
conda install -y -c conda-forge r-base=4.0.5
conda install -y -c conda-forge r-seurat
conda install -y -c conda-forge r-tidyverse
conda install -y -c conda-forge r-amap
conda install -y -c conda-forge r-rtensor
conda install -y -c conda-forge r-hdf5r
conda install -y -c conda-forge r-devtools
conda install -y -c conda-forge r-cairo
conda install -y -c conda-forge r-nntensor
conda install -y -c conda-forge r-ggridges
conda install -y -c conda-forge r-umap
conda install -y -c conda-forge r-rcppcnpy
conda install -y -c bioconda bioconductor-limma
conda install -y -c bioconda bioconductor-preprocesscore
Rscript CreateEnv/Create_R405.R


