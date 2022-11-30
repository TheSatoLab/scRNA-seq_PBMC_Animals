#!/usr/bin/env python

import sys,re
args = sys.argv

ID_d = {}
f1 = open(args[1])
next(f1)
for line in f1:
  line = line.strip().split()
  ID_d[line[4]] = []

print("Other_GeneID\tOther_symbol")
f2 = open(args[2])
for line in f2:
  if line[0] == "#": continue
  line = line.strip().split("\t")
  info = line[8]
  if "GeneID" not in info: continue
  info = info.split(";")
  for data in info:
    if 'db_xref "GeneID:' in data:
      GeneID = re.sub(r' db_xref "GeneID:([0-9]+)"',r'\1',data)
    if 'gene "' in data:
      gene = re.sub(r'gene "([^;]+)"',r'\1',data)
  if GeneID not in ID_d: continue
  if gene in ID_d[GeneID]: continue
  ID_d[GeneID].append(gene)
  print("\t".join([str(c) for c in [GeneID, gene]]))

