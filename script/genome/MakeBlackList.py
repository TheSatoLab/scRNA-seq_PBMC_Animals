#!/usr/bin/env python3

import sys,re
args = sys.argv

f1 = open(args[1])
ch_l = []
for line in f1: ch_l.append(line.strip())

ch_s = set(ch_l)

biotype_l = ["protein_coding","transcribed_pseudogene","lncRNA","pseudogene","antisense_RNA","ncRNA_pseudogene",
             "V_segment","V_segment_pseudogene","C_region","C_region_pseudogene","J_segment","J_segment_pseudogene","D_segment"]
f2 = open(args[2])
print("seqname\tstart\tend\tgene\tgene_biotype")
for line in f2:
  if line[0] == "#": continue
  line = line.strip("\n")
  if 'gene_id ""' in line: continue
  line = line.split("\t")
  if line[0] not in ch_s: continue
  if line[2] != "gene": continue
  data = line[8].split("; ")
  biotype=""
  for i in range(len(data)):
    if 'gene "' in data[i]:
      gene = re.sub(r'gene "(.+)"',r'\1',data[i])
    if 'gene_biotype "' in data[i]:
      biotype = re.sub(r'gene_biotype "(.+)"',r'\1',data[i])
  if biotype not in biotype_l:
    print("\t".join([str(c) for c in [line[0],int(line[3])-1,line[4],gene,biotype]]))



