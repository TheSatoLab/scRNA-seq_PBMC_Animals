#!/usr/bin/env R

update.packages(oldPkgs = c("withr", "rlang"))
install.packages('remotes')
remotes::install_github('satijalab/azimuth', ref = 'master')
devtools::install_github("hoxo-m/pforeach")

install.packages("BiocManager")
BiocManager::install("ComplexHeatmap")
BiocManager::install("GSVA")
BiocManager::install("fgsea")
BiocManager::install("edgeR")


