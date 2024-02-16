#!/bin/bash

function process-one {
  DATA=$1
  EXCLUDE_IMAGES_MULTIPLE=$2

  # Set the gain to 2 to reduce I/sigma estimates, otherwise shelxt 2018/2 will fail to solve the structure!
  # I think that is because that version rejects space groups for which mean I/sigma(I) > 5 for systematic
  # absences
  dials.import ../../$DATA/SMV/data/*.img geometry.goniometer.axis=-0.645847,-0.763426,0 panel.gain=2
  dials.generate_mask imported.expt \
      untrusted.rectangle=0,516,255,261\
      untrusted.rectangle=255,261,0,516
  dials.apply_mask imported.expt mask=pixels.mask
  dials.find_spots masked.expt\
      exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE d_max=10 d_min=0.6 nproc=12
  dials.index masked.expt strong.refl detector.fix=distance space_group=F222
  # Reindex into the correct cell for the known space group
  dials.reindex indexed.expt indexed.refl change_of_basis_op=b,c,a space_group=Fdd2
  dials.refine reindexed.expt reindexed.refl detector.fix=distance
  dials.integrate refined.expt refined.refl prediction.d_min=0.6\
      exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE nproc=12
}

function scale_and_solve {
    INTENSITY_CHOICE=$1

    dials.scale\
      ../Data1/integrated.{expt,refl}\
      ../Data2/integrated.{expt,refl}\
      ../Data3/integrated.{expt,refl}\
      ../Data4/integrated.{expt,refl}\
      intensity_choice=$INTENSITY_CHOICE
    dials.export scaled.{expt,refl} format=shelx

    mkdir -p solve
    cd solve
    cp ../dials.hkl .
    cat <<EOF > dials.ins
TITL Fdd2
CELL 0.0251 18.374 18.669  6.767  90.000  90.000  90.000
ZERR 1.00    0.000  0.000  0.000   0.000   0.000   0.000
LATT -4
SYMM -X,-Y,Z
SYMM -X+1/4,Y+1/4,Z+1/4
SYMM X+1/4,-Y+1/4,Z+1/4
SFAC SI  2.1293 57.7748  2.5333 16.4756         =
         0.8349  2.8796  0.3216  0.3860  0.0000 =
         0.0000  0.0000  0.0000  1.1100 28.0860
SFAC AL  2.2756 72.3220  2.4280 19.7729         =
         0.8578  3.0799  0.3166  0.4076  0.0000 =
         0.0000  0.0000  0.0000  1.1800 26.9815
SFAC NA  2.2406 108.0039  1.3326 24.5047         =
         0.9070  3.3914  0.2863  0.4346  0.0000 =
         0.0000  0.0000  0.0000  1.4000 22.9900
SFAC O   0.4548 23.7803  0.9173  7.6220         =
         0.4719  2.1440  0.1384  0.2959  0.0000 =
         0.0000  0.0000  0.0000  0.7300 15.9990
SFAC H   0.3754 15.4946  0.1408  4.1261         =
         0.0216  0.0246 -0.1012 46.8840  0.0000 =
         0.0000  0.0000  0.0000  0.3200  1.0080
UNIT 2 1 1 6 2
TREF 5000
HKLF 4
END
EOF

    shelxt dials > shelxt.log
    cd ..

    mkdir -p refine
    cd refine
    cp ../dials.hkl .
    # FIXME refinement here
    cd ..
}


# Process each dataset
mkdir -p Data1
cd Data1
process-one Data1 20
cd ..

mkdir -p Data2
cd Data2
# reciprocal lattice looks distorted even after refinement. Might be due to beam drift?
process-one Data2 20
cd ..

mkdir -p Data3
cd Data3
# there are two lattices in this one - worth processing the second?
process-one Data3 20
cd ..

mkdir -p Data4
# Nice one
cd Data4
process-one Data4 20
cd ..


# Solve structure with different intensity choices for scaling
mkdir -p solve1
cd solve1/
scale_and_solve "combine"
cd ..

mkdir -p solve2
cd solve2/
scale_and_solve "profile"
cd ..
