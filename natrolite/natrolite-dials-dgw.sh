#!/bin/bash

set -x

# Check script input
if [ "$#" -ne 1 ]; then
    echo "You must supply the location of the data parent directory " \
"(containing Data{1..4}/ only"
    exit 1
fi
PARENTDIR=$(realpath "$1")

function process-one {
  DATA=$1
  EXCLUDE_IMAGES_MULTIPLE=$2

  dials.import "$PARENTDIR"/"$DATA"/SMV/data/*.img\
    geometry.goniometer.axis=-0.645847,-0.763426,0 panel.gain=2.9
  dials.generate_mask imported.expt \
    untrusted.rectangle=0,516,255,261\
    untrusted.rectangle=255,261,0,516
  dials.apply_mask imported.expt mask=pixels.mask
  dials.find_spots masked.expt\
    exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE\
    d_max=10 d_min=0.6 gain=0.5
  dials.index masked.expt strong.refl\
    detector.fix=distance space_group=F222
  # Reindex into the correct cell for the known space group
  dials.reindex indexed.expt indexed.refl\
    change_of_basis_op=b,c,a space_group=Fdd2
  dials.refine reindexed.expt reindexed.refl detector.fix=distance
  dials.plot_scan_varying_model refined.expt
  dials.integrate refined.expt refined.refl prediction.d_min=0.6\
      exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE

  dials.python ~/sw/Angelina-DIALS-proc/sum_vs_prf_plot.py
}

function scale_and_solve {

    # Data2 is weak, and excluding it gives better merging stats and R1
    # values.
    dials.two_theta_refine \
      ../Data1/integrated.{expt,refl}\
      ../Data3/integrated.{expt,refl}\
      ../Data4/integrated.{expt,refl}

    dials.scale refined_cell.expt\
      ../Data1/integrated.refl\
      ../Data3/integrated.refl\
      ../Data4/integrated.refl\
      merging.nbins=10\
      d_min=0.61


    # Get cell and intensity cluster information
    dials.cluster_unit_cell scaled.expt > dials.cluster_unit_cell.log
    xia2.cluster_analysis scaled.expt scaled.refl

    dials.export scaled.expt scaled.refl format=shelx composition="Si Al Na O H"

    # Also export as MTZ for xia2.compare_merging_stats
    dials.export scaled.expt scaled.refl

    mkdir -p solve
    cd solve
    cp ../dials.{hkl,ins} .

    shelxt dials > shelxt.log
    cd ..

    mkdir -p refine
    cd refine
    cp ../dials.hkl .
    cat <<EOF > dials.ins
TITL natrolite in Fdd2
CELL 0.0251 18.374 18.669  6.767  90.000  90.000  90.000
ZERR 8 0 0 0 0 0 0
LATT -4
SYMM -X,-Y,+Z
SYMM 0.25-X,0.25+Y,0.25+Z
SYMM 0.25+X,0.25-Y,0.25+Z
SFAC  Al 0.358 0.453 0.975 3.774 2.639 23.386 1.91 80.502 0 0 0 0 1.26 26.982
SFAC  H 0.037 0.561 0.127 3.791 0.236 13.556 0.129 37.723 0 0 0 0 0.32 1.008
SFAC  Na 0.332 0.495 0.986 4.085 1.488 31.511 1.966 118.494 0 0 0 0 1.55 22.99
SFAC  O 0.143 0.305 0.51 2.268 0.937 8.262 0.392 25.665 0 0 0 0 0.63 15.999
SFAC  Si 0.363 0.428 0.974 3.557 2.721 19.39 1.766 64.333 0 0 0 0 1.16 28.086
UNIT 16 32 16 96 24
L.S. 4
PLAN  5
TEMP 19.85
CONF
fmap 2
MORE -1
BOND \$H
WGHT 0.2
FVAR 0.69546
Si1   5     10.00000  10.00000  10.00000  10.50000  0.02158  0.01509 =
 0.01114  10.00000  10.00000  0.00234
Si2   5     0.09656  0.03819 -0.37284  11.00000  0.00488  0.01467  0.01434 =
 -0.00179  0.00096  0.00130
Al1   1    -0.03734  0.09417  0.38743  11.00000  0.01489  0.01497  0.01632 =
 -0.00359 -0.00326  0.00244
Na1   3    -0.22067  0.03194  0.38774  11.00000  0.03779  0.01814  0.02588 =
 0.00550  0.00046  0.00151
O1    4     0.06915  0.02354 -0.13854  11.00000  0.02115  0.02286  0.01592 =
 -0.00492  0.00018 -0.00480
O2    4    -0.02192  0.06803  0.14028  11.00000  0.02952  0.02039  0.01614 =
 0.00021  0.00024  0.00670
O3    4    -0.06987  0.18190  0.39575  11.00000  0.01417  0.01367  0.01842 =
 -0.00258 -0.00324  0.00160
O4    4    -0.09561  0.03645  0.50592  11.00000  0.04773  0.01312  0.02976 =
 0.00909  0.01654 -0.00163
O5    4     0.04279  0.09796  0.52687  11.00000  0.02890  0.01533  0.02420 =
 0.00027 -0.00711  0.01419
O6    4    -0.30573  0.06071  0.64572  11.00000  0.00665  0.04508  0.03230 =
 0.01250 -0.00474  0.00354
H     2    -0.40949  0.06448  0.49965  11.00000  10.04670
H6    2    -0.32299  0.11996  0.73896  11.00000  10.04670
HKLF 4
END
EOF

    shelxl dials > shelxl.log
    cd ..
}

# Process each dataset
mkdir -p Data1
cd Data1
process-one Data1 20
cd ..

mkdir -p Data2
cd Data2
# A bit weak
process-one Data2 20
cd ..

mkdir -p Data3
cd Data3
# There are two lattices in this one, or split crystal - worth processing the second?
process-one Data3 20
cd ..

mkdir -p Data4
cd Data4
process-one Data4 20
cd ..

# Scale, solve and refine
mkdir -p scale
cd scale/
scale_and_solve
cd ..
