#!/bin/env dials.python

from dials.array_family import flex
import pandas as pd
from matplotlib import pyplot as plt

rt = flex.reflection_table.from_file("integrated.refl")
_, _, z = rt["xyzobs.px.value"].parts()

sel_sum = rt.get_flags(rt.flags.integrated_sum)
sel_prf = rt.get_flags(rt.flags.integrated_prf)

# Round up to integer image number
z = flex.ceil(z)

z_sum = list(z.select(sel_sum))
z_prf = list(z.select(sel_prf))

print(f"Selected {len(z_sum)} summation integrated reflections")
print(f"Selected {len(z_prf)} profile fitted reflections")

sum_counts = pd.Series(z_sum).value_counts().sort_index()
prf_counts = pd.Series(z_prf).value_counts().sort_index()

# https://stackoverflow.com/questions/51520189/zero-occurrences-frequency-using-value-counts-in-pandas
sum_counts = sum_counts.reindex(range(1, int(max(z_sum)) + 1), fill_value = 0)
prf_counts = prf_counts.reindex(range(1, int(max(z_prf)) + 1), fill_value = 0)

plt.plot(sum_counts.index, sum_counts.values, label = "summation")
plt.plot(prf_counts.index, prf_counts.values, label = "profile fit")
plt.xlabel("Image")
plt.ylabel("Number integrated")
plt.legend()
plt.savefig("sum_vs_int.pdf")
