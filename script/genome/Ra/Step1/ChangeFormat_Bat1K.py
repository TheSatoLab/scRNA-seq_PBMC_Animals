#!/usr/bin/env python3

import sys,re
from gtfparse import read_gtf
import pandas as pd
args = sys.argv

df = read_gtf(args[1])
df_f = df[['seqname','source','feature','start','end','score','strand','frame','gene_id']]
df_fe = df_f[df_f["feature"] == "exon"]
df_fe.to_csv(args[2],sep="\t",index=False)




