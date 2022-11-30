#!/usr/bin/env bash
#$ -S /bin/bash
#$ -l s_vmem=8G,mem_req=8G
#$ -cwd
#$ -q mjobs.q
#$ -j y
#$ -N Filter
#$ -o o/

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate py38

#Species=Rousettus_aegyptiacus
mkdir -p ../output/ortholog/orthologID_Filtered
tail -n +2 ../input/SampleInfo.txt | cut -f 2 | sort | uniq | tail -n +2 | xargs -n 1 -P 3 bash -c \
'
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate py38

Species=${0}
python genome/ortholog/orthologFilter/orthologIDFilter.py \
${Species} \
../output/ortholog/gene_orthologs \
> ../output/ortholog/orthologID_Filtered/Hs_${Species}_orthologsID.txt
'

mkdir -p ../output/ortholog/GeneID_genename
python genome/ortholog/orthologFilter/Gtf_GeneID_genename_Hs.py \
../output/genome/Homo_sapiens/GCF_000001405.39_GRCh38.p13_genomic.gtf \
> ../output/ortholog/GeneID_genename/Homo_sapiens.txt

python genome/ortholog/orthologFilter/Gtf_GeneID_genename.py \
../output/ortholog/orthologID_Filtered/Hs_Pan_troglodytes_orthologsID.txt \
../output/genome/Pan_troglodytes/GCF_002880755.1_Clint_PTRv2_genomic.gtf \
> ../output/ortholog/GeneID_genename/Pan_troglodytes.txt

python genome/ortholog/orthologFilter/Gtf_GeneID_genename.py \
../output/ortholog/orthologID_Filtered/Hs_Macaca_mulatta_orthologsID.txt \
../output/genome/Macaca_mulatta/GCF_003339765.1_Mmul_10_genomic.gtf \
> ../output/ortholog/GeneID_genename/Macaca_mulatta.txt

python genome/ortholog/orthologFilter/Gtf_GeneID_genename.py \
../output/ortholog/orthologID_Filtered/Hs_Rousettus_aegyptiacus_orthologsID.txt \
../output/genome/Rousettus_aegyptiacus/GCF_014176215.1_mRouAeg1.p_genomic.gtf \
> ../output/ortholog/GeneID_genename/Rousettus_aegyptiacus.txt

#Species=Rousettus_aegyptiacus
mkdir -p ../output/ortholog/orthologList
tail -n +2 ../input/SampleInfo.txt | cut -f 2 | sort | uniq | tail -n +2 | xargs -n 1 -P 3 bash -c \
'
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

Species=${0}
R --slave --vanilla --args \
../output/ortholog/orthologID_Filtered/Hs_${Species}_orthologsID.txt \
../output/ortholog/GeneID_genename/${Species}.txt \
../output/ortholog/GeneID_genename/Homo_sapiens.txt \
../output/ortholog/orthologList/Hs_${Species}_orthologs.txt \
< genome/ortholog/orthologFilter/MakeOrthologList.R
'

conda activate R405

R --slave --vanilla --args \
../output/ortholog/orthologList/Hs_Pan_troglodytes_orthologs.txt \
../output/ortholog/orthologList/Hs_Macaca_mulatta_orthologs.txt \
../output/ortholog/orthologList/Hs_Rousettus_aegyptiacus_orthologs.txt \
../output/ortholog/preHs_orthologs.txt \
< genome/ortholog/orthologFilter/MergeOrthologList.R




