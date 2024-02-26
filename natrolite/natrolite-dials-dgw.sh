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
