#!/usr/bin/env bash

mkdir -p ../output/genome/Rousettus_aegyptiacus/subGTF/Step2
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate py38

bedtools intersect \
-s -wao \
-a ../output/genome/Rousettus_aegyptiacus/subGTF/Step1/Bat1KrouAeg4_Chr.bed \
-b ../output/genome/Rousettus_aegyptiacus/subGTF/Step1/RefSeq.bed \
> ../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_RefSeq_intersect.bed

python genome/Ra/Step2/CalcGeneLength.py \
../output/genome/Rousettus_aegyptiacus/subGTF/Step1/Bat1KrouAeg4_Chr.bed \
> ../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_Chr_GeneLength.txt

python genome/Ra/Step2/CalcGeneLength.py \
../output/genome/Rousettus_aegyptiacus/subGTF/Step1/RefSeq.bed \
> ../output/genome/Rousettus_aegyptiacus/subGTF/Step2/RefSeq_GeneLength.txt

python genome/Ra/Step2/Bat1K_RefSeq_OverlapInfo.py \
../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_RefSeq_intersect.bed \
../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_Chr_GeneLength.txt \
../output/genome/Rousettus_aegyptiacus/subGTF/Step2/RefSeq_GeneLength.txt \
../output/ortholog/preHs_orthologs.txt \
../output/genome/Homo_sapiens/RefSeq_gene.txt \
> ../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_RefSeq_OverlapInfo.txt

conda activate R4.0.5
R --vanilla --slave --args \
../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_RefSeq_OverlapInfo.txt \
../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_RefSeq_SameGenes.txt \
../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_RefSeq_nonOverlap.txt \
../output/genome/Rousettus_aegyptiacus/subGTF/Step2/Bat1KrouAeg4_RefSeq_Overlap_nonOrtholog_DifferentSymbol.txt \
< genome/Ra/Step2/Remove_Ortholog_SameSymbol.R



