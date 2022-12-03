#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

mkdir -p ../output/Mendeley/ExpData

mkdir -p ../output/Mendeley/ExpData/RawCount
ls ../output/genome/ | xargs -n 1 -P 4 bash -c \
'
Species=${0}
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
${Species} \
../output/Exp/Seurat/Merge/${Species}/${Species}_RNA.rds \
../output/Mendeley/ExpData/RawCount/RawCount_${Species}.rds \
< Mendeley/ExpData/RawCount.R
'

mkdir -p ../output/Mendeley/ExpData/SCTCount
ls ../output/genome/ | xargs -n 1 -P 4 bash -c \
'
Species=${0}
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
${Species} \
../output/Exp/Seurat/Merge/${Species}/${Species}_SCT.rds \
../output/Mendeley/ExpData/SCTCount/SCTCount_${Species}.rds \
< Mendeley/ExpData/SCTCount.R
'

mkdir -p ../output/Mendeley/ExpData/SCT_CP10K
ls ../output/genome/ | xargs -n 1 -P 4 bash -c \
'
Species=${0}
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
${Species} \
../output/Exp/Seurat/Merge/${Species}/${Species}_SCT.rds \
../output/Mendeley/ExpData/SCT_CP10K/SCT_CP10K_${Species}.rds \
< Mendeley/ExpData/SCT_CP10K.R
'

mkdir -p ../output/Mendeley/ExpData/integrated
ls ../output/genome/ | xargs -n 1 -P 4 bash -c \
'
Species=${0}
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
${Species} \
../output/Exp/Seurat/Merge/${Species}/${Species}_integrated.rds \
../output/Mendeley/ExpData/integrated/integrated_${Species}.rds \
< Mendeley/ExpData/integrated.R
'





