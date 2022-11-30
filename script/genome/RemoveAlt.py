#!/usr/bin/env python3

import sys,re
from Bio import SeqIO
args = sys.argv

out_l = []
for record in SeqIO.parse(args[1], "fasta"):
  if "alternate" not in record.description:
    out_l.append(record)
    print(record.id)

SeqIO.write(out_l, args[2], "fasta")


