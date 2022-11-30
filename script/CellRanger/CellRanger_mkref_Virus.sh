#!/usr/bin/env bash
#$ -S /bin/bash
#$ -l s_vmem=8G,mem_req=8G
#$ -cwd
#$ -q '!mjobs_rerun.q'
#$ -pe def_slot 8
#$ -j y
#$ -N mkref
#$ -o log/CellRanger/

CellRanger=~/local/src/cellranger-6.0.1
PATH=$PATH:${CellRanger}
source ${CellRanger}/sourceme.bash
mkdir -p ../output/CellRanger_ref

Species=`tail -n +2 ../input/SampleInfo.txt | cut -f 2 | sort | uniq | head -n ${SGE_TASK_ID} | tail -n 1`
cd ../output/CellRanger_ref
fasta=../genome/${Species}/${Species}_Virus.fa
gtf=../genome/${Species}/${Species}_Virus.gtf
${CellRanger}/cellranger mkref \
--genome=${Species}_Virus \
--fasta=${fasta} \
--genes=${gtf} \
--nthreads=7 \
--memgb=50


