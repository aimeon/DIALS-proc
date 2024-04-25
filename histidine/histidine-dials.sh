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

  dials.import "$PARENTDIR"/"$DATA"/frames/*.rodhypix\
    geometry.goniometer.axis=0.0488498,-0.998806,0 # about 2.8° off "vertical"
  dials.find_spots imported.expt d_max=10
  dials.index imported.expt strong.refl\
    detector.fix=distance space_group=P212121\
    max_lattices="$MAX_LATTICES" minimum_angular_separation=1
  dials.refine indexed.expt indexed.refl\
    detector.fix=distance crystal.unit_cell.force_static=True
  dials.plot_scan_varying_model refined.expt
  dials.integrate refined.expt refined.refl prediction.d_min=0.6
}

function scale_and_solve {
    FILTER=$1

    if [ "$FILTER" = "filter" ]; then
        dials.scale\
          ../exp_705/integrated.{expt,refl}\
          ../exp_706/integrated.{expt,refl}\
          ../exp_707/integrated.{expt,refl}\
          ../exp_708/integrated.{expt,refl}\
          ../exp_710/integrated.{expt,refl}\
          ../exp_711/integrated.{expt,refl}\
          ../exp_712/integrated.{expt,refl}\
          ../exp_713/integrated.{expt,refl}\
          ../exp_715/integrated.{expt,refl}\
          d_min=0.64\
          filtering.method=deltacchalf\
          deltacchalf.mode=image_group
    else
        dials.scale\
          ../exp_705/integrated.{expt,refl}\
          ../exp_706/integrated.{expt,refl}\
          ../exp_707/integrated.{expt,refl}\
          ../exp_708/integrated.{expt,refl}\
          ../exp_710/integrated.{expt,refl}\
          ../exp_711/integrated.{expt,refl}\
          ../exp_712/integrated.{expt,refl}\
          ../exp_713/integrated.{expt,refl}\
          ../exp_715/integrated.{expt,refl}\
          d_min=0.64
    fi

    # Get cell and intensity cluster information
    dials.cluster_unit_cell scaled.expt > dials.cluster_unit_cell.log
    xia2.cluster_analysis scaled.expt scaled.refl

    dials.export scaled.{expt,refl} format=shelx composition="CHNO"

    mkdir -p solve
    cd solve
    cp ../dials.{hkl,ins} .
    shelxt dials > shelxt.log
    cd ..
}

# Process each dataset

mkdir -p exp_705 # 2 lattices?
cd exp_705
process-one exp_705 2
cd ..

mkdir -p exp_706
cd exp_706
process-one exp_706 1
cd ..

mkdir -p exp_707
cd exp_707
process-one exp_707 1
cd ..

mkdir -p exp_708
cd exp_708
process-one exp_708 1
cd ..

mkdir -p exp_710 # 2 lattices? Second is quite bad
cd exp_710
process-one exp_710 2
cd ..

mkdir -p exp_711
cd exp_711
process-one exp_711 1
cd ..

mkdir -p exp_712 # 2 lattices
cd exp_712
process-one exp_712 2
cd ..

mkdir -p exp_713
cd exp_713
process-one exp_713 1
cd ..

mkdir -p exp_715
cd exp_715
process-one exp_715 1
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
