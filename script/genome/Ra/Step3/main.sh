#!/usr/bin/env bash

mkdir -p ../output/genome/Rousettus_aegyptiacus/subGTF/Step3

conda activate py38

python genome/Ra/Step3/MakeGTF_RefSeq.py \
../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_RefSeq_SameGenes.txt \
../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_RefSeq_Overlap_nonOrtholog_DifferentSymbol.txt \
../output/genome/Rousettus_aegyptiacus/subGTF/Step1/RefSeq.txt \
> ../output/genome/Rousettus_aegyptiacus/subGTF/Step3/RefSeq_mod.gtf


python genome/Ra/Step3/MakeGTF_Bat1K.py \
../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_RefSeq_SameGenes.txt \
../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_RefSeq_nonOverlap.txt \
../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_RefSeq_Overlap_nonOrtholog_DifferentSymbol.txt \
../output/genome/Rousettus_aegyptiacus/subGTF/Step1/Bat1KrouAeg4_Chr.txt \
> ../output/genome/Rousettus_aegyptiacus/subGTF/Step3/Bat1K_mod.gtf

cat ../output/genome/Rousettus_aegyptiacus/subGTF/Step3/RefSeq_mod.gtf \
../output/genome/Rousettus_aegyptiacus/subGTF/Step3/Bat1K_mod.gtf \
> ../output/genome/Rousettus_aegyptiacus/Rousettus_aegyptiacus.gtf

