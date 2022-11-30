#!/usr/bin/env python

import sys,re
args = sys.argv
taxID_Hs = "9606"
if args[1] == "Pan_troglodytes": taxID2 = "9598"
if args[1] == "Macaca_mulatta": taxID2 = "9544"
if args[1] == "Rousettus_aegyptiacus": taxID2 = "9407"

f = open(args[2])
print(next(f)[1:].strip())
for line in f:
  line = line.strip().split()
  if line[0] == taxID_Hs and line[3] == taxID2:
    print("\t".join([str(c) for c in line]))

 
