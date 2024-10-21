#!/bin/env dials.python

from dxtbx.model.experiment_list import ExperimentList
from dials.array_family import flex
from cctbx import crystal, miller
from matplotlib.figure import Figure
import numpy as np
import math

experiments = ExperimentList.from_file("scaled.expt")
reflections = flex.reflection_table.from_file("scaled.refl")

print(f"Loaded {len(reflections)} scaled reflections")

unit_cell = experiments[0].crystal.get_unit_cell()
space_group = experiments[0].crystal.get_space_group()

miller_set = miller.set(
    crystal_symmetry=crystal.symmetry(
        unit_cell=unit_cell,
        space_group=space_group,
    ),
    indices=reflections["miller_index"],
    anomalous_flag=False,
)

i_obs = miller.array(miller_set, data=reflections["intensity.scale.value"])
i_obs.set_observation_type_xray_intensity()
i_obs.set_sigmas(flex.sqrt(reflections["intensity.scale.variance"]))

sys_abs = reflections.select(i_obs.sys_absent_flags().data())
print(f"Selected {len(sys_abs)} systematically absent reflections")

sys_abs.as_file("sys_abs.refl")
print("Wrote sys_abs.refl")

sys_abs["i_over_sigma"] = sys_abs["intensity.scale.value"] / flex.sqrt(sys_abs["intensity.scale.variance"])
sys_abs["d_star_sq"] = 1 / flex.pow2(sys_abs["d"])

fg = Figure()
ax = fg.gca()

# Colour each crystal separately
colors = ["#e41a1c", "#377eb8", "#4daf4a"]
labels = ["Data1", "Data3", "Data4"]
for i in range(len(experiments)):
    sel = sys_abs["id"] == i
    ax.scatter(sys_abs["d_star_sq"].select(sel), sys_abs["i_over_sigma"].select(sel), color=colors[i], label=labels[i])

# Top 3 reflections
sys_abs.sort("i_over_sigma", reverse=True)
strongest = sys_abs[0:3]
for ref in strongest.rows():
    _, _, z = ref["xyzcal.px"]
    print(str(ref["miller_index"]) + f' on image {int(round(z))}, experiment {ref["id"]}. I/σ(I) = {ref["i_over_sigma"]:.2f}')
    ax.text(ref["d_star_sq"] + 0.05, ref["i_over_sigma"], str(ref["miller_index"]))

xticks = np.arange(2.78, 0.011, -0.55)
xlabels = [round(1/math.sqrt(e), 2) for e in xticks]
ax.set_xticks(xticks, labels=xlabels)
ax.set_xlabel("$\it{d}$ (Å)")
ax.set_ylabel("$I/\sigma(I)$")
ax.legend()

fg.savefig("sys_abs.pdf")

