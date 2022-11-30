#!/usr/bin/env python3

import sys,re
from gtfparse import read_gtf
import pandas as pd
args = sys.argv

raw = read_gtf(args[1])
raw_f = raw[['seqname','source','feature','start','end','score','strand','frame',
       'gene','transcript_id','exon_number']]
raw_fe = raw_f[raw_f["feature"] == "exon"]
raw_count = len(set(raw_fe.gene))

mod = read_gtf(args[2])
mod_f = mod[['seqname','source','feature','start','end','score','strand','frame',
       'gene','transcript_id','exon_number']]
mod_fe = mod_f[mod_f["feature"] == "exon"]
mod_count = len(set(mod_fe.gene))

print("raw","mod")
print("\t".join([str(c) for c in [raw_count,mod_count]]))


