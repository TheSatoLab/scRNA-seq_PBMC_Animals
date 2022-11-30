#!/usr/bin/env bash

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate py38

python genome/ortholog/AddRaOrtholog.py \
../output/genome/Rousettus_aegyptiacus/Rousettus_aegyptiacus_Virus.gtf \
../output/ortholog/preHs_orthologs.txt \
> ../output/ortholog/Hs_orthologs.txt


python genome/ortholog/OrthologCounts.py \
../output/ortholog/preHs_orthologs.txt \
../output/ortholog/Hs_orthologs.txt \
> ../output/ortholog/OrthologCounts.txt


