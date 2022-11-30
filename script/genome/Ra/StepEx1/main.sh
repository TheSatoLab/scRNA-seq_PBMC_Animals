#!/usr/bin/env bash

mkdir -p ../output/genome/Rousettus_aegyptiacus/subGTF/StepEx1

conda activate py38

python genome/Ra/StepEx1/ReturnNS.py \
../output/genome/Rousettus_aegyptiacus/subGTF/Step3/Bat1K_mod.gtf \
> ../output/genome/Rousettus_aegyptiacus/subGTF/StepEx1/Bat1K_mod_ReturnNS.gtf

cat ../output/genome/Rousettus_aegyptiacus/subGTF/Step3/RefSeq_mod.gtf \
../output/genome/Rousettus_aegyptiacus/subGTF/StepEx1/Bat1K_mod_ReturnNS.gtf \
> ../output/genome/Rousettus_aegyptiacus/Rousettus_aegyptiacus.gtf



