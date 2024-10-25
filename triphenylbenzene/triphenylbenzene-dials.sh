#!/bin/bash

set -x

# Check script input
if [ "$#" -ne 1 ]; then
    echo "You must supply the location of the data parent directory " \
"(containing 03/ 06/ 07/ 08/)"
    exit 1
fi
PARENTDIR=$(realpath "$1")

function process-one {
  DATA=$1

  dials.import "$PARENTDIR"/"$DATA"/*.cbf\
    panel.gain=1.6\
    geometry.goniometer.axis=-0.052336,0.99863,0 # always 3° off "vertical"
  dials.find_spots imported.expt d_max=10
  dials.index imported.expt strong.refl\
    detector.fix=distance space_group=P222
  dials.refine indexed.expt indexed.refl\
    detector.fix=distance crystal.unit_cell.force_static=True
  dials.plot_scan_varying_model refined.expt
  dials.integrate refined.expt refined.refl prediction.d_min=0.65
}

function scale_and_solve {
    dials.two_theta_refine\
      ../03/integrated.{expt,refl}\
      ../06/integrated.{expt,refl}\
      ../07/integrated.{expt,refl}\
      ../08/integrated.{expt,refl}

    # There seems to be no advantage to doing ΔCC1/2 filtering in this
    # case, nor setting min_Ih=10. So the scaling job is simple.
    dials.scale refined_cell.expt\
      ../03/integrated.refl\
      ../06/integrated.refl\
      ../07/integrated.refl\
      ../08/integrated.refl\
      merging.nbins=10\
      d_min=0.75

    # Get cell and intensity cluster information
    dials.cluster_unit_cell scaled.expt > dials.cluster_unit_cell.log
    xia2.cluster_analysis scaled.expt scaled.refl

    dials.export scaled.{expt,refl} format=shelx composition="CH"

    mkdir -p solve
    cd solve
    cp ../dials.{hkl,ins} .
    shelxt dials > shelxt.log
    cd ..
}

# Process each dataset

mkdir -p 03
cd 03
process-one 03
cd ..

mkdir -p 06
cd 06
process-one 06
cd ..

mkdir -p 07
cd 07
process-one 07
cd ..

mkdir -p 08
cd 08
process-one 08
cd ..

# Scale, solve, and refine
mkdir -p scale_all_reflections
cd scale_all_reflections/
scale_and_solve
cd ..

