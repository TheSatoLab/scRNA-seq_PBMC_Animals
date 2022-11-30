#!/usr/bin/env bash

tail -n +2 ../input/SampleInfo.txt | cut -f 2 | sort | uniq | xargs -n 1 -P 4 bash -c \
'
Species=${0}

python3 genome/RemoveAlt.py \
../output/genome/${Species}/GCF_*.fna \
../output/genome/${Species}/${Species}.fa \
> ../output/genome/${Species}/ChNames.txt

cat ../output/genome/${Species}/${Species}.fa \
../input/VirusInfo/genome/SeV.fa \
../input/VirusInfo/genome/HSV1.fa \
> ../output/genome/${Species}/${Species}_Virus.fa

rm ../output/genome/${Species}/${Species}.fa
'

