#!/usr/bin/env bash

mkdir -p ../output/experiments
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../input/experiments/FC/ \
../output/experiments/FC.pdf \
< experiments/FC.R

R --vanilla --slave --args \
../input/experiments/ViralRNA/ \
../output/experiments/SeV.pdf \
< experiments/SeV.R

R --vanilla --slave --args \
../input/experiments/ViralRNA/ \
../output/experiments/HSV1.pdf \
< experiments/HSV1.R

