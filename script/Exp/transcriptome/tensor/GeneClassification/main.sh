#!/usr/bin/env bash

mkdir -p ../output/Exp/transcriptome/tensor/GeneClassification

. ~/hd04/local/src/miniconda3/etc/profile.d/conda.sh
conda activate R405

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Exp/transcriptome/tensor/GeneClassification/SixTensor.rds \
< Exp/transcriptome/tensor/GeneClassification/Make6Tensor.R

R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/GeneClassification/SixTensor.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Data_product.rds \
< Exp/transcriptome/tensor/GeneClassification/MakeProduct.R


conda activate py38
python Exp/transcriptome/tensor/GeneClassification/MakeL1List.py \
> ../output/Exp/transcriptome/tensor/GeneClassification/L1List.txt

python Exp/transcriptome/tensor/GeneClassification/MakeL1List_Stim.py \
> ../output/Exp/transcriptome/tensor/GeneClassification/L1List_Stim.txt


conda activate R405
R --vanilla --slave --args \
../output/Exp/transcriptome/tensor/TD/TDres.rds \
../output/Exp/transcriptome/tensor/GeneClassification/Stim2Cell3Matrix.rds \
< Exp/transcriptome/tensor/GeneClassification/MakeStim2Cell3Matrix.R

bash Exp/transcriptome/tensor/GeneClassification/Pattern/Common/main.sh
bash Exp/transcriptome/tensor/GeneClassification/Pattern/Ra/main.sh
bash Exp/transcriptome/tensor/GeneClassification/Pattern/Mm/main.sh

