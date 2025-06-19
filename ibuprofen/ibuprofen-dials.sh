#!/bin/bash

set -x

# Check script input
if [ "$#" -ne 1 ]; then
    echo "You must supply the location of the data parent directory RR-3/ " \
"downloaded and unpacked from https://zenodo.org/records/7848949"
    exit 1
fi
PARENTDIR=$(realpath "$1")

function process-one {
  DATA=$1
  EXCLUDE_IMAGES_MULTIPLE=$2

  dials.import "$PARENTDIR"/"$DATA"/XDS/*.img\
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
          ../1/integrated.{expt,refl}\
          ../2/integrated.{expt,refl}\
          ../6/integrated.{expt,refl}\
          ../7/integrated.{expt,refl}\
          ../8/integrated.{expt,refl}\
          ../3/integrated.{expt,refl}\
          ../4/integrated.{expt,refl}\
          ../5/integrated.{expt,refl}\
          merging.nbins=10\
          filtering.method=deltacchalf\
          deltacchalf.mode=image_group\
          deltacchalf.group_size=5\
          deltacchalf.stdcutoff=3\
          d_min=0.92\
          min_Ih=10
    elif [ "$FILTER" = "firsthalf" ]; then
        dials.scale\
          ../1/integrated.{expt,refl}\
          ../2/integrated.{expt,refl}\
          ../6/integrated.{expt,refl}\
          ../7/integrated.{expt,refl}\
          ../8/integrated.{expt,refl}\
          ../3/integrated.{expt,refl}\
          ../4/integrated.{expt,refl}\
          ../5/integrated.{expt,refl}\
          merging.nbins=10\
          d_min=0.92\
          min_Ih=10\
          exclude_images=0:66:131,1:74:146,2:85:168,3:67:132,4:59:117,5:43:84,6:75:148,7:65:129
    elif [ "$FILTER" = "manual" ]; then
        dials.scale\
          ../1/integrated.{expt,refl}\
          ../2/integrated.{expt,refl}\
          ../6/integrated.{expt,refl}\
          ../7/integrated.{expt,refl}\
          ../8/integrated.{expt,refl}\
          ../3/integrated.{expt,refl}\
          ../4/integrated.{expt,refl}\
          ../5/integrated.{expt,refl}\
          merging.nbins=10\
          d_min=0.92\
          min_Ih=10\
          exclude_images=0:120:143,2:80:173,3:85:143,4:90:119,5:43:86,6:100:149
    else
        dials.scale\
          ../1/integrated.{expt,refl}\
          ../2/integrated.{expt,refl}\
          ../6/integrated.{expt,refl}\
          ../7/integrated.{expt,refl}\
          ../8/integrated.{expt,refl}\
          ../3/integrated.{expt,refl}\
          ../4/integrated.{expt,refl}\
          ../5/integrated.{expt,refl}\
          merging.nbins=10\
          d_min=1.0\
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

mkdir -p 1
cd 1
process-one 1 20
cd ..

mkdir -p 2
cd 2
process-one 2 20
cd ..

# radiation damage and powder rings
mkdir -p 6
cd 6
process-one 6 20
cd ..

# radiation damage and powder rings
mkdir -p 7
cd 7
process-one 7 20
cd ..

# high resolution, some radiation damage
mkdir -p 8
cd 8
process-one 8 20
cd ..

# A bit weak
mkdir -p 3
cd 3
process-one 3 20
cd ..

# radiation damage
mkdir -p 4
cd 4
process-one 4 20
cd ..

# quite high resolution
mkdir -p 5
cd 5
process-one 5 20
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
