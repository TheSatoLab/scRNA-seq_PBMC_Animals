#!/usr/bin/env python

import sys,re
args = sys.argv

##############################################################################################
data_d = {}
Bat1K_l = []
noOverlapCandidate_d = {}
f1 = open(args[1])
for line in f1:
  line = line.strip().split()
  if line[9] == ".":
    if line[3] not in noOverlapCandidate_d.keys():
      noOverlapCandidate_d[line[3]] = {'seqname':line[0],'strand':line[5],'Bat1K':line[3]}    
    continue
  Bat1K = line[3]
  Bat1K_l.append(Bat1K)
  RefSeq = line[9]
  Bat1K_RefSeq = Bat1K + "::" + RefSeq
  if Bat1K_RefSeq not in data_d.keys():
    data_d[Bat1K_RefSeq] = {'seqname':line[0],'strand':line[5],'Bat1K':Bat1K,'RefSeq':RefSeq,
                            'OverlapStatus':'Overlap','OverlapLength':int(line[12])}
  else:
    data_d[Bat1K_RefSeq]['OverlapLength'] += int(line[12])

Bat1K_s = set(Bat1K_l)

for Bat1K in noOverlapCandidate_d.keys():
  if Bat1K not in Bat1K_s:
    data_d[Bat1K] = {'seqname':noOverlapCandidate_d[Bat1K]['seqname'],
                     'strand' :noOverlapCandidate_d[Bat1K]['strand'],
                     'Bat1K'  :noOverlapCandidate_d[Bat1K]['Bat1K'],
                     'OverlapStatus':"noOverlap"}


##############################################################################################
Bat1K_Length_d = {}
f2 = open(args[2])
for line in f2:
  line = line.strip().split()
  Bat1K_Length_d[line[0]] = line[1]

RefSeq_Length_d = {}
f3 = open(args[3])
for line in f3:
  line = line.strip().split()
  RefSeq_Length_d[line[0]] = line[1]

ortholog_d = {}
f4 = open(args[4])
next(f4)
for line in f4:
  line = line.strip().split()
  if line[3] == "NA": continue
  ortholog_d[line[3]] = {'Hs':line[0],'Ra':line[3]}

Hs_l = []
f5 = open(args[5])
next(f5)
for line in f5:
  line = line.strip().split("\t")
  Hs_l.append(line[8])
  
Hs_s = set(Hs_l)

##############################################################################################
header_l = ["UniqueID","seqname","Bat1K","Bat1K_Length","gRefSeq","tRefSeq","RefSeq_Length",
            "strand","OverlapStatus","Overlap_Length","OrthologStatus","SymbolStatus",
            "Bat1K_HsStatus","RefSeq_HsStatus","Bat1K_LOC","RefSeq_LOC"]
print("\t".join([str(c) for c in header_l]))
for Bat1K_RefSeq in data_d.keys():
  data = data_d[Bat1K_RefSeq]
  seqname = data["seqname"]
  strand = data["strand"]
  Bat1K = data["Bat1K"]
  Bat1K_Length = Bat1K_Length_d[Bat1K]
  OverlapStatus = data["OverlapStatus"]
  if OverlapStatus == "Overlap":
    RefSeq = data["RefSeq"]
    gRefSeq = re.sub(r'(.+)__.+',r'\1',RefSeq)
    tRefSeq = re.sub(r'.+__(.+)',r'\1',RefSeq)
    RefSeq_Length = RefSeq_Length_d[RefSeq]
    Overlap_Length = data["OverlapLength"]
    if gRefSeq not in ortholog_d.keys():
      OrthologStatus = "nonOrtholog"
    else:
      if ortholog_d[gRefSeq]["Hs"] != Bat1K:
        OrthologStatus = "nonOrtholog"
      else:
        OrthologStatus = "Ortholog"
    UniqueID = "__".join([str(c) for c in [Bat1K,gRefSeq,tRefSeq]])
  else:
    RefSeq = "NA"
    gRefSeq = "NA"
    tRefSeq = "NA"
    RefSeq_Length = "NA"
    Overlap_Length = "NA"
    OrthologStatus = "nonOrtholog"
    UniqueID = Bat1K
  if Bat1K == gRefSeq:
    SymbolStatus = "SameSymbol"
  else:
    SymbolStatus = "DifferentSymbol"
  if Bat1K in Hs_s:
    Bat1K_HsStatus = "HsGene"
  else:
    Bat1K_HsStatus = "nonHsGene"
  if gRefSeq in Hs_s:
    RefSeq_HsStatus = "HsGene"
  else:
    RefSeq_HsStatus = "nonHsGene"
  if Bat1K[:3] == "LOC":
    Bat1K_LOC = "LOC"
  else:
    Bat1K_LOC = "notLOC"
  if gRefSeq[:3] == "LOC":
    RefSeq_LOC = "LOC"
  else:
    RefSeq_LOC = "notLOC"
  out_l = [UniqueID,seqname,Bat1K,Bat1K_Length,gRefSeq,tRefSeq,RefSeq_Length,
           strand,OverlapStatus,Overlap_Length,OrthologStatus,SymbolStatus,
           Bat1K_HsStatus,RefSeq_HsStatus,Bat1K_LOC,RefSeq_LOC]
  print("\t".join([str(c) for c in out_l]))


