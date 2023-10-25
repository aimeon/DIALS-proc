#!/usr/bin/env dials.python

from dxtbx.model.experiment_list import ExperimentList
from dials.array_family import flex
import sys

indexed_expt = sys.argv[1]
indexed_refl = indexed_expt.replace("expt", "refl")

experiments = ExperimentList.from_file(indexed_expt)
reflections = flex.reflection_table.from_file(indexed_refl)

cell = experiments[0].crystal.get_unit_cell().parameters()
a, b, c , aa, bb, cc = cell
msg = f"{indexed_expt}: unit cell: {a:.4f} {b:.4f} {c:.4f} {aa:.4f} {bb:.4f} {cc:.4f} "
n_indexed = reflections.get_flags(reflections.flags.indexed).count(True)
msg += f"indexed {n_indexed}/{len(reflections)} "
if n_indexed < 0.5 * len(reflections):
  msg += "REJECT "

expected_a = 13.5512 
expected_b = 20.0053
expected_c = 20.2291

if abs(expected_a - a) / expected_a > 0.1:
  msg += f"a={a} REJECT "
if abs(expected_b - b) / expected_b > 0.1:
  msg += f"b={b} REJECT "
if abs(expected_c - c) / expected_c > 0.1:
  msg += f"c={c} REJECT "
  
print(msg)
