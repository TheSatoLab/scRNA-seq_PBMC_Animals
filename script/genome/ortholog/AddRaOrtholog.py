#!/usr/bin/env python

import sys,re
args = sys.argv

gene_l = []
f1 = open(args[1])
for line in f1:
  line = line.strip("\n").split("\t")
  line9 = line[8].split("; ")
  for data in line9:
    if "gene_id" in data:
      gene = re.sub(r'gene_id "(.+)"',r'\1',data)
  gene_l.append(gene)

gene_s = set(gene_l)

f2 = open(args[2])
print(next(f2).strip("\n"))
for line in f2:
  line = line.strip().split()
  if line[0] in gene_s:
    line[3] = line[0]
  print("\t".join([str(c) for c in line]))

print("TLR9\tTLR9\tTLR9\tTLR9")

