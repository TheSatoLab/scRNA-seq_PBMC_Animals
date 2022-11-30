#!/usr/bin/env python3

import sys,re
from gtfparse import read_gtf
import pandas as pd
args = sys.argv

df = read_gtf(args[1])
df_f = df[['seqname','source','feature','start','end','score','strand','frame',
       'gene','transcript_id','exon_number']]
df_fe = df_f[df_f["feature"] == "exon"]
df_fe.to_csv(args[2],sep="\t",index=False)

df_fe["start"] -= 1
df_fe["score"] = 0
df_fe["name"] = df_fe["gene"] + "__" + df_fe["transcript_id"]
df_fef = df_fe[['seqname','start','end','name','score','strand']]
df_fef.to_csv(args[3],sep="\t",index=False,header=False)

