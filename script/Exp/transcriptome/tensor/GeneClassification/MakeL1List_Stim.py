#!/usr/bin/env python

Cell_l = ["B","TNK","Mono"]
L1_l = ["L1_1","L1_2","L1_3"]
Stim_l = ["Virus","LPS"]

print("\t".join([str(c) for c in ["ID","Cell","L1","Stim"]]))
for L1 in L1_l:
  for Stim in Stim_l:
    for Cell in Cell_l:
      ID = "__".join([Cell,L1,Stim])
      print("\t".join([str(c) for c in [ID,Cell,L1,Stim]]))


