#!/usr/bin/env bash

mkdir -p ../output/Exp/transcriptome/CellSubset/CheckAllCellType

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

echo -e "Species\tCellType" > ../output/Exp/transcriptome/CellSubset/CheckAllCellType/ID_l.txt
for Species in Homo_sapiens Pan_troglodytes Macaca_mulatta Rousettus_aegyptiacus ; do
  for CellType in B TNK Mono ; do
    echo -e "${Species}\t${CellType}" >> ../output/Exp/transcriptome/CellSubset/CheckAllCellType/ID_l.txt
  done
done

mkdir -p ../output/Exp/transcriptome/CellSubset/CheckAllCellType/UMAP_data
tail -n +2 ../output/Exp/transcriptome/CellSubset/CheckAllCellType/ID_l.txt | xargs -n 2 -P 6 bash -c \
'
Species=${0}
CellType=${1}
. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/Seurat/Merge/${Species}/${Species}.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_integrated.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_SCT.rds \
../output/Exp/Seurat/Merge/${Species}/${Species}_metadata.rds \
${CellType} \
../output/Exp/transcriptome/CellSubset/CheckAllCellType/UMAP_data/${Species}_${CellType}.rds \
< Exp/transcriptome/CellSubset/CheckAllCellType/UMAP.R
'

R --vanilla --slave --args \
../output/Exp/transcriptome/CellSubset/CheckAllCellType/UMAP_data/ \
../output/Exp/transcriptome/CellSubset/CheckAllCellType/AllUMAP.pdf \
< Exp/transcriptome/CellSubset/CheckAllCellType/UMAP_All.R






