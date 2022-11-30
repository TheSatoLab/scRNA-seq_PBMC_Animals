#!/usr/bin/env python

import sys,re

args = sys.argv

overlap_d = {}
Bat1K_d = {}
RefSeq_d = {}
f1 = open(args[1])
for line in f1:
  line = line.strip().split()
  comb = line[7] + "__" + line[3]
  if comb not in overlap_d.keys():
    overlap_d[comb] = [line[0],line[7],line[3]]
  if line[7] not in Bat1K_d.keys():
    Bat1K_d[line[7]] = [line[0]]
  if line[3] not in RefSeq_d.keys():
    RefSeq_d[line[3]] = line[0]


Bat1K_Info_d = {}
f2 = open(args[2])
next(f2)
for line in f2:
  line = line.strip().split("\t")
  if line[8] not in Bat1K_d.keys(): continue
  if line[8] not in Bat1K_Info_d.keys():
    Bat1K_Info_d[line[8]] = {'seqname':line[0],'strand':line[6],'exon_count':1,'exon_d':{'exon_1':[line[3],line[4]]}}
  else:
    Bat1K_Info_d[line[8]]['exon_count'] = Bat1K_Info_d[line[8]]['exon_count'] + 1
    exon_ID = 'exon_' + str(Bat1K_Info_d[line[8]]['exon_count'])
    Bat1K_Info_d[line[8]]['exon_d'][exon_ID] = [line[3],line[4]]

#{'APOR': {'seqname': 'NW_023416298.1', 'strand': '+', 'exon_count': 4, 'exon_d': {'exon_1': ['25485', '25572'], 'exon_2': ['28535', '28705'], 'exon_3': ['30623', '30798'], 'exon_4': ['31352', '31486']}}, 'MAGEB16F': {'seqname': 'NW_023416300.1', 'strand': '-', 'exon_count': 1, 'exon_d': {'exon_1': ['95101', '96147']}}, 'MAGEB3B': {'seqname': 'NW_023416302.1', 'strand': '-', 'exon_count': 1, 'exon_d': {'exon_1': ['18179', '19216']}}, 'MAGEB3': {'seqname': 'NW_023416302.1', 'strand': '+', 'exon_count': 1, 'exon_d': {'exon_1': ['58105', '59136']}}}

SearchRegion_dg = {}
SearchRegion_d = {}
for gene in Bat1K_Info_d.keys():
  start_l,end_l = [],[]
  exon_d = Bat1K_Info_d[gene]["exon_d"]
  for exon in exon_d.keys():
    start_l.append(int(exon_d[exon][0]))
    end_l.append(int(exon_d[exon][1]))
  Bat1K_Info_d[gene]['min_start'] = min(start_l)
  Bat1K_Info_d[gene]['max_end'] = max(end_l)
  Bat1K_Info_d[gene]['length'] = Bat1K_Info_d[gene]['max_end'] - Bat1K_Info_d[gene]['min_start']
  AddLength = max([Bat1K_Info_d[gene]['length'],10000])
  Bat1K_Info_d[gene]['searchFrom'] = Bat1K_Info_d[gene]['min_start'] - AddLength
  Bat1K_Info_d[gene]['searchTo'] = Bat1K_Info_d[gene]['max_end'] + AddLength
  SearchRegion_dg[gene] = [Bat1K_Info_d[gene]['seqname'],Bat1K_Info_d[gene]['searchFrom'],Bat1K_Info_d[gene]['searchTo']]
  if Bat1K_Info_d[gene]['seqname'] not in SearchRegion_d.keys():
    SearchRegion_d[Bat1K_Info_d[gene]['seqname']] = []
  SearchRegion_d[Bat1K_Info_d[gene]['seqname']].append([Bat1K_Info_d[gene]['searchFrom'],Bat1K_Info_d[gene]['searchTo']])


#for gene in Bat1K_Info_d.keys():
#  print("\t".join([str(c) for c in [gene,Bat1K_Info_d[gene]['length']]]))
  
  
#Bat1K_Info_d{'APOR': {'seqname': 'NW_023416298.1', 'strand': '+', 'exon_count': 4, 'exon_d': {'exon_1': ['25485', '25572'], 'exon_2': ['28535', '28705'], 'exon_3': ['30623', '30798'], 'exon_4': ['31352', '31486']}, 'min_start': 25485, 'max_end': 31486, 'length': 6001, 'searchFrom': 15485, 'searchTo': 41486}}
#SearchRegion_dg{'APOR': ['NW_023416298.1', 15485, 41486], 'MAGEB16F': ['NW_023416300.1', 85101, 106147]}
#SearchRegion_d{'NW_023416296.1': [[202716, 309075], [63057, 296178], [212823, 239098], [526419, 546838], [538001, 558411], [831793, 852389], [842845, 863345], [847378, 867773], [847959, 868402], [936062, 979565], [955644, 976192], [1244485, 1271605], [1264280, 1459946], [1543205, 1636718], [1766774, 1818734], [1803014, 1827857]]}




RefSeq_allInfo_d = {}
f3 = open(args[3])
next(f3)
for line in f3:
  line = line.strip().split("\t")
  ProcessID=0
  if line[8] not in RefSeq_allInfo_d.keys():
    if line[0] not in SearchRegion_d.keys(): continue
    RefSeq_allInfo_d[line[8]] = {'seqname':line[0],'strand':line[6],'transcript_id_count':1,'transcript_d':{line[9]:{'exon_count':1,'exon_d':{line[10]:[line[3],line[4]]}}}}
  else:
    if line[9] not in RefSeq_allInfo_d[line[8]]['transcript_d'].keys():
      RefSeq_allInfo_d[line[8]]['transcript_id_count'] += 1
      RefSeq_allInfo_d[line[8]]['transcript_d'][line[9]] = {'exon_count':1,'exon_d':{line[10]:[line[3],line[4]]}}
    else:
      RefSeq_allInfo_d[line[8]]['transcript_d'][line[9]]['exon_count'] += 1
      RefSeq_allInfo_d[line[8]]['transcript_d'][line[9]]['exon_d'][line[10]] = [line[3],line[4]]


#RefSeq_allInfo_d["TSG101"]{'seqname': 'NW_023416308.1', 'strand': '-', 'transcript_id_count': 1, 'transcript_d': {'XM_016134336.2': {'exon_count': 10, 'exon_d': {'1': ['89493173', '89493351'], '2': ['89487396', '89487480'], '3': ['89485425', '89485490'], '4': ['89483119', '89483282'], '5': ['89479017', '89479143'], '6': ['89475654', '89475720'], '7': ['89472237', '89472328'], '8': ['89464369', '89464571'], '9': ['89462818', '89463057'], '10': ['89461254', '89461588']}}}}

RefSeq_Info_d = {}
for gene in RefSeq_allInfo_d.keys():
  check = 0
  for transcript_id in RefSeq_allInfo_d[gene]['transcript_d'].keys():
    if check != 0: continue
    for exon in RefSeq_allInfo_d[gene]['transcript_d'][transcript_id]['exon_d'].keys():
      if check != 0: continue
      region_check = 0
      for region in SearchRegion_d[RefSeq_allInfo_d[gene]['seqname']]:
        if region[0] < int(RefSeq_allInfo_d[gene]['transcript_d'][transcript_id]['exon_d'][exon][0]) < region[1]: region_check += 1
        if region[0] < int(RefSeq_allInfo_d[gene]['transcript_d'][transcript_id]['exon_d'][exon][1]) < region[1]: region_check += 1
      if region_check != 0:
        RefSeq_Info_d[gene] = RefSeq_allInfo_d[gene]
        check += 1




