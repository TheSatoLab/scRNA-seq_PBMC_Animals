#!/usr/bin/env bash
#$ -S /bin/bash
#$ -l s_vmem=8G,mem_req=8G
#$ -cwd
#$ -q mjobs.q
#$ -j y
#$ -N Download
#$ -o o/

mkdir -p ../output/ortholog
wget -P ../output/ortholog \
https://ftp.ncbi.nih.gov/gene/DATA/gene_orthologs.gz
gunzip ../output/ortholog/gene_orthologs.gz
date >> ../output/ortholog/DownloadDate_gene_orthologs.txt


