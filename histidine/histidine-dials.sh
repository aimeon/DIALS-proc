#!/bin/bash

# Download data sets from https://zenodo.org/records/10974780

set -x

# Check script input
if [ "$#" -ne 1 ]; then
    echo "You must supply the location of the data parent directory " \
"(containing exp_705/ to exp_715/)"
    exit 1
fi
PARENTDIR=$(realpath "$1")

function process-one {
  DATA=$1
  MAX_LATTICES=$2
  IMAGE_RANGE=$3

  # Rotation axis about 2.9° off "vertical". Panel gain as reported by R. Buecker
  dials.import "$PARENTDIR"/"$DATA"/frames/*.rodhypix\
    panel.gain=2.9\
    geometry.goniometer.axes=0,-1,0,\
0,-0.642788,0.766044,\
0.050593,-0.99872,0\
  image_range="$IMAGE_RANGE"
  dials.find_spots imported.expt d_max=10 gain=0.5
  dials.index imported.expt strong.refl\
    detector.fix=distance space_group=P212121\
    max_lattices="$MAX_LATTICES" minimum_angular_separation=1
  dials.refine indexed.expt indexed.refl\
    detector.fix=distance
  dials.plot_scan_varying_model refined.expt
  dials.integrate refined.expt refined.refl prediction.d_min=0.6
}

function scale_and_solve {
    FILTER=$1

    dials.two_theta_refine\
      ../exp_705/integrated.{expt,refl}\
      ../exp_706/integrated.{expt,refl}\
      ../exp_707/integrated.{expt,refl}\
      ../exp_708/integrated.{expt,refl}\
      ../exp_710/integrated.{expt,refl}\
      ../exp_711/integrated.{expt,refl}\
      ../exp_712/integrated.{expt,refl}\
      ../exp_713/integrated.{expt,refl}\
      ../exp_715/integrated.{expt,refl}

    if [ "$FILTER" = "filter" ]; then
        dials.scale refined_cell.expt\
          ../exp_705/integrated.refl\
          ../exp_706/integrated.refl\
          ../exp_707/integrated.refl\
          ../exp_708/integrated.refl\
          ../exp_710/integrated.refl\
          ../exp_711/integrated.refl\
          ../exp_712/integrated.refl\
          ../exp_713/integrated.refl\
          ../exp_715/integrated.refl\
          merging.nbins=10\
          d_min=0.64\
          filtering.method=deltacchalf\
          deltacchalf.mode=image_group
    else
        dials.scale refined_cell.expt\
          ../exp_705/integrated.refl\
          ../exp_706/integrated.refl\
          ../exp_707/integrated.refl\
          ../exp_708/integrated.refl\
          ../exp_710/integrated.refl\
          ../exp_711/integrated.refl\
          ../exp_712/integrated.refl\
          ../exp_713/integrated.refl\
          ../exp_715/integrated.refl\
          merging.nbins=10\
          d_min=0.64
    fi

    # Get cell and intensity cluster information
    dials.cluster_unit_cell scaled.expt > dials.cluster_unit_cell.log
    xia2.cluster_analysis scaled.expt scaled.refl

    dials.export scaled.{expt,refl} format=shelx composition="C H N O Cl"

    mkdir -p solve
    cd solve
    cp ../dials.{hkl,ins} .
    shelxt dials > shelxt.log
    cd ..
}

# Process each dataset

mkdir -p exp_705 # 2 lattices
cd exp_705
process-one exp_705 2 1,484
cd ..

mkdir -p exp_706
cd exp_706
process-one exp_706 1 1,604
cd ..

mkdir -p exp_707
cd exp_707
process-one exp_707 1 1,604
cd ..

mkdir -p exp_708
cd exp_708
process-one exp_708 1 1,604
cd ..

mkdir -p exp_710 # 2 lattices. Second is quite bad. Don't use
cd exp_710
process-one exp_710 1 1,604
cd ..

mkdir -p exp_711
cd exp_711
process-one exp_711 1 70,604
cd ..

mkdir -p exp_712 # Split first lattice and a second one. Not worth including the second one
cd exp_712
process-one exp_712 1 1,629
cd ..

mkdir -p exp_713
cd exp_713
process-one exp_713 1 1,617
cd ..

mkdir -p exp_715
cd exp_715
process-one exp_715 1 1,612
cd ..

# Scale, solve, and refine
mkdir -p scale_all_reflections
cd scale_all_reflections/
scale_and_solve
cd ..

mkdir -p scale_filtered
cd scale_filtered
scale_and_solve "filter"
cd ..

