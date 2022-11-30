#!/usr/bin/env python

import sys,re
args = sys.argv

SameGenes_d_Bat1K = {}
f1 = open(args[1])
for line in f1:
  line = line.strip().split("\t")
  if line[2] not in SameGenes_d_Bat1K.keys(): SameGenes_d_Bat1K[line[2]] = line


noOverlap_d = {}
f2 = open(args[2])
for line in f2:
  line = line.strip().split("\t")
  noOverlap_d[line[2]] = line
  

OtherGenes_d = {}
f3 = open(args[3])
for line in f3:
  line = line.strip().split("\t")
  if line[2] not in OtherGenes_d.keys(): OtherGenes_d[line[2]] = line


exon_d = {}
f4 = open(args[4])
next(f4)
for line in f4:
  line = line.strip("\n").split("\t")
  Chr_Symbol = line[0] + "__" + line[8]
  if Chr_Symbol not in exon_d.keys():
    exon_d[Chr_Symbol] = {'total':1,'count':1}
  else:
    exon_d[Chr_Symbol]['total'] += 1


f4 = open(args[4])
next(f4)
for line in f4:
  line = line.strip("\n").split("\t")
  out_l = line[:8]
  out_l[5],out_l[7] = ".","."
  if line[8] in SameGenes_d_Bat1K.keys():
    symbol,Chr,strand = line[8],line[0],line[6]
  elif line[8] in noOverlap_d.keys():
    symbol,Chr,strand = line[8],line[0],line[6]
  elif line[8] in OtherGenes_d.keys():
    Info = OtherGenes_d[line[8]]
    LOC = Info[14] + '__' + Info[15]
    if LOC == "notLOC__LOC":
      symbol,Chr,strand = line[8],line[0],line[6]
    elif LOC == "LOC__notLOC":
      continue
    else:
      Hs = Info[12] + '__' + Info[13]
      if Hs == "HsGene__nonHsGene":
        symbol,Chr,strand = line[8],line[0],line[6]
      else:
        continue
  else:
    symbol,Chr,strand = line[8],line[0],line[6]
  gene_id = 'gene_id "' + symbol + '"'
  transcript_id = 'transcript_id "' + symbol + '_' + Chr + '_Bat1K"'
  gene = 'gene "' + symbol + '"'
  Chr_Symbol = line[0] + "__" + line[8]
  if strand == "+":
    exon_number = 'exon_number "' + str(exon_d[Chr_Symbol]['count']) + '"'
    exon_d[Chr_Symbol]['count'] += 1
  else:
    exon_number = 'exon_number "' + str(exon_d[Chr_Symbol]['total']) + '"'
    exon_d[Chr_Symbol]['total'] -= 1
  line9 = '; '.join([str(c) for c in [gene_id,transcript_id,gene,exon_number]]) + '; '
  out_l.append(line9)
  print("\t".join([str(c) for c in out_l]))

      

