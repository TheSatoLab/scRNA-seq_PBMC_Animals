#!/usr/bin/env bash

bash Exp/transcriptome/tensor/Preprocess/main.sh
bash Exp/transcriptome/tensor/TD/main.sh
bash Exp/transcriptome/tensor/GeneClassification/main.sh
bash Exp/transcriptome/tensor/RaSpecific/main.sh


