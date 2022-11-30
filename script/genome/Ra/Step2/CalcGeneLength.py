#!/usr/bin/env python

import sys,re
args = sys.argv

Gene_d = {}
f1 = open(args[1])
for line in f1:
  line = line.strip().split()
  if line[3] not in Gene_d.keys():
    Gene_d[line[3]] = int(line[2]) - int(line[1])
  else:
    Add = int(line[2]) - int(line[1])
    Gene_d[line[3]] += Add

for gene in Gene_d.keys():
  print("\t".join([str(c) for c in [gene,Gene_d[gene]]]))


