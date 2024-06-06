#!/bin/env dials.python

from dxtbx.model.experiment_list import ExperimentList
import sys
from dxtbx import flumpy
import numpy as np
from scitbx.math import five_number_summary

experiments = ExperimentList.from_file(sys.argv[1])
imageset = experiments[0].imageset
depth = 100
nx = 30
ny = 30
stack = np.empty((nx, ny, depth))
mask_stack = np.empty((nx, ny, depth), dtype="bool")
gain=1
for i in range(depth):
    data = flumpy.to_numpy(imageset.get_raw_data(i)[0].as_double()) / gain
    mask = flumpy.to_numpy(imageset.get_mask(i)[0])

    # Mask out calibration images
    if (i + 1)%20 == 0:
        mask = mask != mask

    stack[:,:,i] = data[(512-ny):512,0:nx]
    mask_stack[:,:,i] = mask[(512-ny):512,0:nx]

means = []
variances = []
for i in range(nx):
    for j in range(ny):
        pixel = stack[i,j,:]
        mask = mask_stack[i,j,:]
        pixel = pixel[mask]
        means.append(np.mean(pixel))
        variances.append(np.var(pixel))

dispersion = [v/m for m, v in zip(means, variances) if v > 0]
print("Five number summary of the dispersion")
fns = five_number_summary(dispersion)
print(f"Min: {fns[0]:.2f}")
print(f"Q1:  {fns[1]:.2f}")
print(f"Med: {fns[2]:.2f}")
print(f"Q3:  {fns[3]:.2f}")
print(f"max: {fns[4]:.2f}")
