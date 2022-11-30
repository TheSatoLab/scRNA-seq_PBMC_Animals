#!/usr/bin/env python

import sys,re

args = sys.argv
args = ["","../output/genome/Rousettus_aegyptiacus/subGTF/Step3/Bat1K_mod.gtf"]

tID_l = []
data_d = {}
f = open(args[1])
for line in f:
  line = line.strip("\n").split("\t")
  line1to8_l = line[:8]
  line9 = line[8]
  line9_l = line9.split('; ')
  tID = re.sub(r'transcript_id "(.+)"',r'\1',line9_l[1])
  if tID not in tID_l: tID_l.append(tID)
  tID_i = tID_l.index(tID)
  exonID = int(re.sub(r'exon_number "(.+)"',r'\1',line9_l[3]))
  if tID_i not in data_d.keys(): data_d[tID_i] = {}
  data_d[tID_i][exonID] = line


for i in range(len(tID_l)):
  data = data_d[i]
  for j in range(max(data.keys())):
    jp1 = j + 1
    print("\t".join([str(c) for c in data[jp1]]))



 

