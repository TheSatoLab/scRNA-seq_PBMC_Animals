# Descriptions
This directory contains programs to analyse scRNA-Seq data (GEO: GSE218199).

The analytical pipeline are described in detail elsewhere ([Aso et al, GigaScience, 2023](https://doi.org/10.1101/2022.12.06.519403)).

## main.sh
Main script file.

Please execute main.sh at **script/**.

Simply executing this program will recursively execute the scripts of its descendents.

## Usage
bash main.sh

## Dependencies
This script depends on the following environments and programs:
* Ubuntu (20.04 LTS)
* Conda (v4.9.2)
* CellRanger (v6.0.1)
* bedtools (v2.30.0)
* R (v4.0.5)
* R packages:
   * Seurat (v4.0.4)
   * Azimuth (v0.4.3)
   * GSVA (v1.38.2)
   * rTensor (v1.4.8)
* Python (v3.8.11)
* Python package:
   * TensorLy (v0.6.0)


