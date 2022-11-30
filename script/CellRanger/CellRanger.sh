#!/usr/bin/env bash
#$ -S /bin/bash
#$ -l s_vmem=4.5G,mem_req=4.5G
#$ -cwd
#$ -q '!mjobs_rerun.q'
#$ -pe def_slot 16
#$ -j y
#$ -N CellRanger
#$ -o log/CellRanger/
#$ -hold_jid mkref

CellRanger=~/local/src/cellranger-6.0.1
PATH=$PATH:${CellRanger}
source ${CellRanger}/sourceme.bash

FileID=`tail -n +2 ../input/SampleInfo.txt | cut -f 1 | head -n ${SGE_TASK_ID} | tail -n 1`
Species=`tail -n +2 ../input/SampleInfo.txt | cut -f 2 | head -n ${SGE_TASK_ID} | tail -n 1`
Stim=`tail -n +2 ../input/SampleInfo.txt | cut -f 3 | head -n ${SGE_TASK_ID} | tail -n 1`

mkdir -p ../output/CellRanger/${Stim}
cd ../output/CellRanger/${Stim}
${CellRanger}/cellranger count \
--id=${Species}_${Stim} \
--fastqs=../../../input/fastq/${Stim}/${FileID} \
--sample=${FileID} \
--transcriptome=../../CellRanger_ref/${Species}_Virus \
--localcores=16 \
--localmem=64


