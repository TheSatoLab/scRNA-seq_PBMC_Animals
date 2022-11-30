#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda create --name py38
conda activate py38
conda install -y python=3.8
conda install -y -c bioconda gtfparse
conda install -y -c bioconda bedtools
conda install -y -c conda-forge pyarrow
conda install -y -c conda-forge numpy
conda install -y -c tensorly tensorly

