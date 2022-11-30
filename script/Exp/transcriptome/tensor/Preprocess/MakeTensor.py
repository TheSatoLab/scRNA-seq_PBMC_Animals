#!/usr/bin/env python

import sys,re
import numpy as np
import tensorly as tl
from tensorly import random

args = sys.argv

Species_level = ["Homo_sapiens","Pan_troglodytes",
                   "Macaca_mulatta","Rousettus_aegyptiacus"]
Stim_level =["HSV1","SeV","LPS"]

data_name = args[1] + "Homo_sapiens" + "__" + "HSV1" + ".npy"
data = np.load(data_name)
alldata = random.random_tensor((4, 3, 4, len(data[0])))

for i in range(4):
  Species = Species_level[i]
  for j in range(3):
    Stim = Stim_level[j]
    data_name = args[1] + Species + "__" + Stim + ".npy"
    data = np.load(data_name)
    alldata[i][j] = data


np.save(args[2],alldata)


