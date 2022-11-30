#!/usr/bin/env bash

mkdir -p ../output/genome/Rousettus_aegyptiacus/subGTF/Step1

cat ../input/210714HLrouAeg4Bat1KFinalAnnotaion.gz |
gunzip \
> ../output/genome/Rousettus_aegyptiacus/subGTF/Step1/Bat1KrouAeg4.gtf

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate py38

python3 genome/Ra/Step1/ChangeFormat_RefSeq.py \
../output/genome/Rousettus_aegyptiacus/RefSeq.gtf \
../output/genome/Rousettus_aegyptiacus/subGTF/Step1/RefSeq.txt \
../output/genome/Rousettus_aegyptiacus/subGTF/Step1/RefSeq.bed

python3 genome/Ra/Step1/ChangeFormat_Bat1K.py \
../output/genome/Rousettus_aegyptiacus/subGTF/Step1/Bat1KrouAeg4.gtf \
../input/SymbolRelations.txt \
../output/genome/Rousettus_aegyptiacus/subGTF/Step1/Bat1KrouAeg4.txt

conda activate R4.0.5
R --vanilla --slave --args \
../output/genome/Rousettus_aegyptiacus/subGTF/Step1/Bat1KrouAeg4.txt \
../output/genome/Rousettus_aegyptiacus/BlackList.txt \
../output/genome/Rousettus_aegyptiacus/scaffold_localID2acc \
../output/genome/Rousettus_aegyptiacus/subGTF/Step1/Bat1KrouAeg4_Chr.txt \
../output/genome/Rousettus_aegyptiacus/subGTF/Step1/Bat1KrouAeg4_Chr.bed \
< genome/Ra/Step1/ChangeFormat_Bat1K.R


