#!/usr/bin/env bash

tail -n +2 ../input/SampleInfo.txt | cut -f 2 | sort | uniq | xargs -n 1 -P 4 bash -c \
'
Species=${0}

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate py38

python3 genome/MakeBlackList.py \
../output/genome/${Species}/ChNames.txt \
../output/genome/${Species}/GCF_*.gtf \
> ../output/genome/${Species}/BlackList.txt

python3 genome/GTFfilter.py \
../output/genome/${Species}/ChNames.txt \
../output/genome/${Species}/BlackList.txt \
../output/genome/${Species}/GCF_*.gtf \
> ../output/genome/${Species}/RefSeq.gtf
'

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate py38
python genome/ExtractGene.py \
../output/genome/Homo_sapiens/GCF_*.gtf \
../output/genome/Homo_sapiens/RefSeq_gene.txt

bash genome/Ra/main.sh
mv ../output/genome/Homo_sapiens/RefSeq.gtf ../output/genome/Homo_sapiens/Homo_sapiens.gtf
mv ../output/genome/Pan_troglodytes/RefSeq.gtf ../output/genome/Pan_troglodytes/Pan_troglodytes.gtf
mv ../output/genome/Macaca_mulatta/RefSeq.gtf ../output/genome/Macaca_mulatta/Macaca_mulatta.gtf

tail -n +2 ../input/SampleInfo.txt | cut -f 2 | sort | uniq | xargs -n 1 -P 4 bash -c \
'
Species=${0}

cat ../output/genome/${Species}/${Species}.gtf \
../input/VirusInfo/gtf/SeV.gtf \
../input/VirusInfo/gtf/HSV1.gtf \
> ../output/genome/${Species}/${Species}_Virus.gtf

#rm ../output/genome/${Species}/${Species}.gtf
'

tail -n +2 ../input/SampleInfo.txt | cut -f 2 | sort | uniq | xargs -n 1 -P 4 bash -c \
'
Species=${0}
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate py38
GTF=`ls ../output/genome/${Species}/GCF_*.gtf`
python genome/CountGenes.py \
${GTF} \
../output/genome/${Species}/${Species}.gtf \
> ../output/genome/${Species}/GeneCount.txt
'


