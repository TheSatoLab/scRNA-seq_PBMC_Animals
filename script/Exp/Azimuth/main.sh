#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/AzimuthReference.rds \
< Exp/Azimuth/AzimuthReferenceDownload.R

