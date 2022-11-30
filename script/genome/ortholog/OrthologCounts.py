#!/usr/bin/env python

import sys,re
args = sys.argv

print("\t".join([str(c) for c in ["Hs","Pt","Mm","Ra"]]))

count_l1 = [0,0,0,0]
f1 = open(args[1])
next(f1)
for line in f1:
  line = line.strip().split()
  if line[0] != "NA": count_l1[0] += 1
  if line[1] != "NA": count_l1[1] += 1
  if line[2] != "NA": count_l1[2] += 1
  if line[3] != "NA": count_l1[3] += 1
  
print("\t".join([str(c) for c in count_l1]))

count_l2 = [0,0,0,0]
f2 = open(args[2])
next(f2)
for line in f2:
  line = line.strip().split()
  if line[0] != "NA": count_l2[0] += 1
  if line[1] != "NA": count_l2[1] += 1
  if line[2] != "NA": count_l2[2] += 1
  if line[3] != "NA": count_l2[3] += 1
  
print("\t".join([str(c) for c in count_l2]))


