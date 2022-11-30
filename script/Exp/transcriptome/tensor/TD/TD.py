#!/usr/bin/env python

import sys,re
import numpy as np
import tensorly as tl
from tensorly.decomposition import tucker
import shelve

args = sys.argv

data = np.load(args[1])
ranks = [3,2,3,15]
core, factors = tucker(data,
                       rank = ranks,
                       n_iter_max = 100,
                       init="svd",
                       random_state=np.random.RandomState(1))

np.save(args[2],factors[0])
np.save(args[3],factors[1])
np.save(args[4],factors[2])
np.save(args[5],factors[3])

for i in range(ranks[0]):
  for j in range(ranks[1]):
    ip1 = i + 1
    jp1 = j + 1
    data_name = args[6] + "L1_" + str(ip1) + "__L2_" + str(jp1) + ".npy"
    np.save(data_name,core[i][j])


shelf_file = shelve.open(args[7])
shelf_file["core"] = core
shelf_file["factors"] = factors
shelf_file.close()


