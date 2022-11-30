#!/usr/bin/env python

import sys,re
args = sys.argv

SameGenes_d_RefSeq = {}
f1 = open(args[1])
for line in f1:
  line = line.strip().split("\t")
  if line[4] not in SameGenes_d_RefSeq.keys(): SameGenes_d_RefSeq[line[4]] = line


OtherGenes_d = {}
f2 = open(args[2])
for line in f2:
  line = line.strip().split("\t")
  if line[4] not in OtherGenes_d.keys(): OtherGenes_d[line[4]] = line


f3 = open(args[3])
next(f3)
for line in f3:
  line = line.strip("\n").split("\t")
  out_l,nine_l = line[:8],[]
  out_l[5],out_l[7] = ".","."
  if line[8] in SameGenes_d_RefSeq.keys():
    Info = SameGenes_d_RefSeq[line[8]]
    if Info[2] == Info[4]:
      nine_l = [line[8],line[9],line[10]]
    else:
      nine_l = [Info[2],line[9],line[10]]
  elif line[8] in OtherGenes_d.keys():
    Info = OtherGenes_d[line[8]]
    LOC = Info[14] + '__' + Info[15]
    if LOC == "LOC__notLOC":
      nine_l = [line[8],line[9],line[10]]
    elif LOC == "notLOC__LOC":
      continue
    else:
      Hs = Info[12] + '__' + Info[13]
      if Hs == "HsGene__nonHsGene":
        continue
      else:
        nine_l = [line[8],line[9],line[10]]        
  else:
    nine_l = [line[8],line[9],line[10]]
  gene_id = 'gene_id "' + nine_l[0] + '"'
  transcript_id = 'transcript_id "' + nine_l[1] + '"'
  gene = 'gene "' + nine_l[0] + '"'
  exon_number = 'exon_number "' + nine_l[2] + '"'
  line9 = '; '.join([str(c) for c in [gene_id,transcript_id,gene,exon_number]]) + '; '
  out_l.append(line9)
  print("\t".join([str(c) for c in out_l]))

      
      
      
