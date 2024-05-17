#!/bin/bash

set -x

# Check script input
if [ "$#" -ne 1 ]; then
    echo "You must supply the location of the data parent directory " \
"(containing experiment_{1,3,8,12,14,16,18,19}) only"
    exit 1
fi
PARENTDIR=$(realpath "$1")

function process-one {
  DATA=$1
  EXCLUDE_IMAGES_MULTIPLE=$2

  dials.import "$PARENTDIR"/"$DATA"/SMV/data/*.img\
    geometry.goniometer.axis=-0.6204,-0.7843,0.0000 panel.gain=1.35
  dials.generate_mask imported.expt \
      untrusted.rectangle=0,516,255,261\
      untrusted.rectangle=255,261,0,516
  dials.apply_mask imported.expt mask=pixels.mask
  dials.find_spots masked.expt\
      exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE\
      d_max=10 d_min=0.8 nproc=12
  dials.index masked.expt strong.refl\
    detector.fix=distance space_group=P21
  dials.refine indexed.expt indexed.refl\
    detector.fix=distance crystal.unit_cell.force_static=True
  dials.plot_scan_varying_model refined.expt
  dials.integrate refined.expt refined.refl prediction.d_min=0.8\
      exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE nproc=12
}

function scale_and_solve {
    FILTER=$1

    if [ "$FILTER" = "filter" ]; then
        dials.scale\
          ../experiment_1/integrated.{expt,refl}\
          ../experiment_3/integrated.{expt,refl}\
          ../experiment_8/integrated.{expt,refl}\
          ../experiment_12/integrated.{expt,refl}\
          ../experiment_14/integrated.{expt,refl}\
          ../experiment_16/integrated.{expt,refl}\
          ../experiment_18/integrated.{expt,refl}\
          ../experiment_19/integrated.{expt,refl}\
          merging.nbins=10\
          filtering.method=deltacchalf\
          deltacchalf.mode=image_group\
          deltacchalf.group_size=5\
          deltacchalf.stdcutoff=3\
          d_min=0.92\
          min_Ih=10
    elif [ "$FILTER" = "firsthalf" ]; then
        dials.scale\
          ../experiment_1/integrated.{expt,refl}\
          ../experiment_3/integrated.{expt,refl}\
          ../experiment_8/integrated.{expt,refl}\
          ../experiment_12/integrated.{expt,refl}\
          ../experiment_14/integrated.{expt,refl}\
          ../experiment_16/integrated.{expt,refl}\
          ../experiment_18/integrated.{expt,refl}\
          ../experiment_19/integrated.{expt,refl}\
          merging.nbins=10\
          d_min=0.92\
          min_Ih=10\
          exclude_images=0:66:131,1:74:146,2:85:168,3:67:132,4:59:117,5:43:84,6:75:148,7:65:129
    elif [ "$FILTER" = "manual" ]; then
        dials.scale\
          ../experiment_1/integrated.{expt,refl}\
          ../experiment_3/integrated.{expt,refl}\
          ../experiment_8/integrated.{expt,refl}\
          ../experiment_12/integrated.{expt,refl}\
          ../experiment_14/integrated.{expt,refl}\
          ../experiment_16/integrated.{expt,refl}\
          ../experiment_18/integrated.{expt,refl}\
          ../experiment_19/integrated.{expt,refl}\
          merging.nbins=10\
          d_min=0.92\
          min_Ih=10\
          exclude_images=0:120:143,2:80:173,3:85:143,4:90:119,5:43:86,6:100:149
    else
        dials.scale\
          ../experiment_1/integrated.{expt,refl}\
          ../experiment_3/integrated.{expt,refl}\
          ../experiment_8/integrated.{expt,refl}\
          ../experiment_12/integrated.{expt,refl}\
          ../experiment_14/integrated.{expt,refl}\
          ../experiment_16/integrated.{expt,refl}\
          ../experiment_18/integrated.{expt,refl}\
          ../experiment_19/integrated.{expt,refl}\
          merging.nbins=10\
          d_min=1.2\
          min_Ih=10
    fi

    # Get cell and intensity cluster information
    dials.cluster_unit_cell scaled.expt > dials.cluster_unit_cell.log
    xia2.cluster_analysis scaled.expt scaled.refl

    dials.export scaled.{expt,refl} format=shelx composition="C H O"

    mkdir -p solve
    cd solve
    cp ../dials.{hkl,ins} .
    shelxt dials > shelxt.log
    cd ..

}


# Process each dataset

mkdir -p experiment_1
cd experiment_1
process-one experiment_1 20
cd ..

mkdir -p experiment_3
cd experiment_3
process-one experiment_3 20
cd ..

# radiation damage and powder rings
mkdir -p experiment_8
cd experiment_8
process-one experiment_8 20
cd ..

# radiation damage and powder rings
mkdir -p experiment_12
cd experiment_12
process-one experiment_12 20
cd ..

# high resolution, some radiation damage
mkdir -p experiment_14
cd experiment_14
process-one experiment_14 20
cd ..

# A bit weak
mkdir -p experiment_16
cd experiment_16
process-one experiment_16 20
cd ..

# radiation damage
mkdir -p experiment_18
cd experiment_18
process-one experiment_18 20
cd ..

# quite high resolution
mkdir -p experiment_19
cd experiment_19
process-one experiment_19 20
cd ..

# Scale and solve
mkdir -p scale_all_reflections
cd scale_all_reflections/
scale_and_solve
cd ..

mkdir -p scale_filtered
cd scale_filtered/
scale_and_solve "filter"
cd ..

mkdir -p scale_firsthalf
cd scale_firsthalf/
scale_and_solve "firsthalf"
cd ..

mkdir -p scale_manual
cd scale_manual/
scale_and_solve "manual"
cd ..
