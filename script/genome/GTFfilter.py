#!/usr/bin/env python3

import sys,re
args = sys.argv

f1 = open(args[1])
ch_l = []
for line in f1: ch_l.append(line.strip())
ch_s = set(ch_l)

f2 = open(args[2])
next(f2)
BlackList = []
for line in f2: BlackList.append(line.strip().split("\t")[3])
BlackList_s = set(BlackList)

f3 = open(args[3])
for line in f3:
  if line[0] == "#": continue
  line = line.strip("\n")
  if 'gene_id ""' in line: continue
  line = line.split("\t")
  if line[0] not in ch_s: continue
  if line[2] != "exon": continue
  data = line[8].split("; ")
  out_l =[]
  for i in range(len(data)):
    if 'gene_id "' in data[i]: out_l.append(data[i])
    if 'gene "' in data[i]:
      gene = re.sub(r'gene "(.+)"',r'\1',data[i])
      for j in range(len(out_l)):
        if "gene_id" in out_l[j]:
          out_l[j] = 'gene_id "' + gene + '"'
      out_l.append(data[i])
    if 'transcript_id "' in data[i]: out_l.append(data[i])
    if 'exon_number "' in data[i]: out_l.append(data[i])
  if gene in BlackList_s: continue
  if 'transcript_id ""' in out_l:
    for i in range(len(out_l)):
      if 'gene_id "' in out_l[i]:
        gene_id = re.sub(r'gene_id "(.+)"',r'\1',out_l[i])
    for i in range(len(out_l)):
      if 'transcript_id "' in out_l[i]:
        modID = 'transcript_id "' + gene + '"'
        out_l[i] = modID
  if 'transcript_id "unknown_transcript_1"' in out_l:
    for i in range(len(out_l)):
      if 'transcript_id "' in out_l[i]:
        modID = 'transcript_id "' + line[0] + '_'  + gene + '_unknown_transcript_1"'
        out_l[i] = modID
  outdata = "; ".join([str(c) for c in out_l]) + "; "
  line[8] = outdata
  print("\t".join([str(c) for c in line]))




