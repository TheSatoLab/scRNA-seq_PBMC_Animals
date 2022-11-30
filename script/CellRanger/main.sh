#!/usr/bin/env bash
#$ -l s_vmem=1G,mem_req=1G
#$ -cwd
#$ -q '!mjobs_rerun.q'
#$ -j y
#$ -o /dev/null

mkdir -p ./log/CellRanger
qsub -t 1-4:1 CellRanger/CellRanger_mkref_Virus.sh
qsub -t 1-14:1 CellRanger/CellRanger_Virus.sh

