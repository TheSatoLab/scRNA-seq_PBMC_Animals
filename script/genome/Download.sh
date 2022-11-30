#!/usr/bin/env bash

#Homo sapiens
mkdir -p ../output/genome/Homo_sapiens
wget -P ../output/genome/Homo_sapiens \
https://ftp.ncbi.nlm.nih.gov/genomes/all/annotation_releases/9606/109.20200228/GCF_000001405.39_GRCh38.p13/GCF_000001405.39_GRCh38.p13_genomic.fna.gz
gunzip ../output/genome/Homo_sapiens/GCF_000001405.39_GRCh38.p13_genomic.fna.gz

wget -P ../output/genome/Homo_sapiens \
https://ftp.ncbi.nlm.nih.gov/genomes/all/annotation_releases/9606/109.20200228/GCF_000001405.39_GRCh38.p13/GCF_000001405.39_GRCh38.p13_genomic.gtf.gz
gunzip ../output/genome/Homo_sapiens/GCF_000001405.39_GRCh38.p13_genomic.gtf.gz

date >> ../output/genome/Homo_sapiens/DownloadDate.txt

#Pan troglodytes (chimpanzee)
mkdir -p ../output/genome/Pan_troglodytes
wget -P ../output/genome/Pan_troglodytes \
https://ftp.ncbi.nlm.nih.gov/genomes/all/annotation_releases/9598/105/GCF_002880755.1_Clint_PTRv2/GCF_002880755.1_Clint_PTRv2_genomic.fna.gz
gunzip ../output/genome/Pan_troglodytes/GCF_002880755.1_Clint_PTRv2_genomic.fna.gz

wget -P ../output/genome/Pan_troglodytes \
https://ftp.ncbi.nlm.nih.gov/genomes/all/annotation_releases/9598/105/GCF_002880755.1_Clint_PTRv2/GCF_002880755.1_Clint_PTRv2_genomic.gtf.gz
gunzip ../output/genome/Pan_troglodytes/GCF_002880755.1_Clint_PTRv2_genomic.gtf.gz

date >> ../output/genome/Pan_troglodytes/DownloadDate.txt

#Macaca mulatta (Rhesus macaque)
mkdir -p ../output/genome/Macaca_mulatta
wget -P ../output/genome/Macaca_mulatta \
https://ftp.ncbi.nlm.nih.gov/genomes/all/annotation_releases/9544/103/GCF_003339765.1_Mmul_10/GCF_003339765.1_Mmul_10_genomic.fna.gz
gunzip ../output/genome/Macaca_mulatta/GCF_003339765.1_Mmul_10_genomic.fna.gz

wget -P ../output/genome/Macaca_mulatta \
https://ftp.ncbi.nlm.nih.gov/genomes/all/annotation_releases/9544/103/GCF_003339765.1_Mmul_10/GCF_003339765.1_Mmul_10_genomic.gtf.gz
gunzip ../output/genome/Macaca_mulatta/GCF_003339765.1_Mmul_10_genomic.gtf.gz

date >> ../output/genome/Macaca_mulatta/DownloadDate.txt

#Rousettus aegyptiacus (Egyptian fruit bat)
mkdir -p ../output/genome/Rousettus_aegyptiacus
wget -P ../output/genome/Rousettus_aegyptiacus \
https://ftp.ncbi.nlm.nih.gov/genomes/all/annotation_releases/9407/101/GCF_014176215.1_mRouAeg1.p/GCF_014176215.1_mRouAeg1.p_genomic.fna.gz
gunzip ../output/genome/Rousettus_aegyptiacus/GCF_014176215.1_mRouAeg1.p_genomic.fna.gz

wget -P ../output/genome/Rousettus_aegyptiacus \
https://ftp.ncbi.nlm.nih.gov/genomes/all/annotation_releases/9407/101/GCF_014176215.1_mRouAeg1.p/GCF_014176215.1_mRouAeg1.p_genomic.gtf.gz
gunzip ../output/genome/Rousettus_aegyptiacus/GCF_014176215.1_mRouAeg1.p_genomic.gtf.gz

date >> ../output/genome/Rousettus_aegyptiacus/DownloadDate.txt

