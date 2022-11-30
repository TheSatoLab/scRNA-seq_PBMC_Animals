#!/usr/bin/env bash

bash genome/Download.sh
bash genome/ortholog/main.sh
bash genome/GenomeFasta.sh
bash genome/GTF.sh
bash genome/ortholog/AddRaOrtholog.sh

