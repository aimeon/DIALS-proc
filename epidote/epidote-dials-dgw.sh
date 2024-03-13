#!/bin/bash

set -x

function process-one {
  DATA=$1
  EXCLUDE_IMAGES_MULTIPLE=$2

  dials.import ../../$DATA/SMV/data/*.img\
    geometry.goniometer.axis=-0.639656,-0.768383,0 panel.gain=1.35
  dials.generate_mask imported.expt \
    untrusted.rectangle=0,516,255,261\
    untrusted.rectangle=255,261,0,516
  dials.apply_mask imported.expt mask=pixels.mask
  dials.find_spots masked.expt\
    exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE\
    d_max=10 d_min=0.55 nproc=12
  dials.index masked.expt strong.refl\
    detector.fix=distance space_group="P2_1/m"
  dials.refine indexed.expt indexed.refl\
    detector.fix=distance crystal.unit_cell.force_static=True
  dials.plot_scan_varying_model refined.expt
  dials.integrate refined.expt refined.refl prediction.d_min=0.5\
    exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE nproc=12
}

function scale_and_solve {
    # Omit Data_1 because it is weak. Do not do deltacchalf filtering
    # because it actually makes the final data set worse in this case.
    dials.scale\
      ../Data_2/integrated.{expt,refl}\
      ../Data_3/integrated.{expt,refl}\
      ../Data_4/integrated.{expt,refl}\
      ../Data_5/integrated.{expt,refl}\
      d_min=0.55

    # Get cell and intensity cluster information
    dials.cluster_unit_cell scaled.expt > dials.cluster_unit_cell.log
    xia2.cluster_analysis scaled.expt scaled.refl

    # Export to dials.hkl
    dials.export scaled.{expt,refl} format=shelx

    # Attempt to solve the structure
    mkdir -p solve
    cd solve
    cp ../dials.hkl .
    cat <<EOF > dials.ins
TITL P2_1/m
CELL 0.0251  9.035  5.795 10.397  90.000 115.659  90.000
ZERR 1.00    0.000  0.000  0.000   0.000   0.000   0.000
LATT 1
SYMM -X,Y,-Z
SFAC SI  2.1293 57.7748  2.5333 16.4756         =
         0.8349  2.8796  0.3216  0.3860  0.0000 =
         0.0000  0.0000  0.0000  1.1100 28.0860
SFAC AL  2.2756 72.3220  2.4280 19.7729         =
         0.8578  3.0799  0.3166  0.4076  0.0000 =
         0.0000  0.0000  0.0000  1.1800 26.9815
SFAC CA  4.4696 99.5228  2.9708 22.6958         =
         1.9696  4.1954  0.4818  0.4165  0.0000 =
         0.0000  0.0000  0.0000  1.4000 40.0800
SFAC FE  2.5440 64.4244  2.3434 14.8806         =
         1.7588  2.8539  0.5062  0.3502  0.0000 =
         0.0000  0.0000  0.0000  1.1700 55.8470
SFAC O   0.4548 23.7803  0.9173  7.6220         =
         0.4719  2.1440  0.1384  0.2959  0.0000 =
         0.0000  0.0000  0.0000  0.7300 15.9990
SFAC H   0.3754 15.4946  0.1408  4.1261         =
         0.0216  0.0246 -0.1012 46.8840  0.0000 =
         0.0000  0.0000  0.0000  0.3200  1.0080
UNIT 3 2 2 1 10 1
TREF 5000
HKLF 4
END
EOF

    shelxt dials -s"P2(1)_m" > shelxt.log
    cd ..

    mkdir -p refine
    cd refine
    cp ../dials.hkl .
    # Refine using a dials.ins based on Angelina's xds_a.res
    cat <<EOF > dials.ins
TITL epidote in P2(1)/m
CELL 0.0251 8.852 5.62 10.185 90 115.517 90
ZERR 2 0 0 0 0 0 0
LATT 1
SYMM -X,0.5+Y,-Z
SFAC  SI 2.129 57.775 2.533 16.476 0.835 2.88 0.322 0.386 0 0 0 0 1.11 28.086
SFAC  AL 2.276 72.322 2.428 19.773 0.858 3.08 0.317 0.408 0 0 0 0 1.18 26.982
SFAC  CA 4.470 99.523 2.971 22.696 1.97 4.195 0.482 0.416 0 0 0 0 1.4 40.08
SFAC  FE 2.544 64.424 2.343 14.881 1.759 2.854 0.506 0.35 0 0 0 0 1.17 55.847
SFAC  O 0.455 23.78 0.917 7.622 0.472 2.144 0.138 0.296 0 0 0 0 0.73 15.999
SFAC  H 0.375 15.495 0.141 4.126 0.022 0.025 -0.101 46.884 0 0 0 0 0.32 1.008
UNIT 6 4 4 2 20 0
L.S. 20
PLAN  5
CONF
BOND
LIST 6
XNPD 0.002
fmap 2
MORE -1
EXTI 692977.873271
WGHT 0.2 0
FVAR 6.988479
Fe1   4     0.29118  0.25000  0.72425  10.50000  0.00626  0.01479  0.00337 =
 0.00000 -0.00158 -0.00000
Ca1   3     0.24135  0.25000  0.34706  10.50000  0.00862  0.01027 -0.00187 =
 -0.00000  0.00295  0.00000
Ca2   3     0.39516  0.25000  0.07633  10.50000  0.00354  0.02264 -0.00160 =
 -0.00000  0.00036  0.00000
Si2   1     0.66066  0.25000  0.45234  10.50000  0.00305  0.00451 -0.00420 =
 -0.00000 -0.00157 -0.00000
Al2   2     1.00000  0.50000  1.00000  10.50000  0.00752  0.00956 -0.00455 =
 -0.00073  0.00217 -0.00283
Si06  1     0.81768  0.25000  1.18379  10.50000  0.00178  0.01027 -0.00382 =
 -0.00000 -0.00087 -0.00000
Al1   2     0.00000  0.00000  0.50000  10.50000  0.00028  0.00654 -0.00456 =
 -0.00152 -0.00237 -0.00194
Si1   1     0.68394  0.25000  0.77574  10.50000  0.00332  0.00692 -0.00028 =
 -0.00000  0.00214  0.00000
O009  5     0.93441  0.25000  1.09533  10.50000  0.00629  0.00650 -0.00262 =
 -0.00000  0.00257  0.00000
O00A  5     0.95874  0.25000  1.35461  10.50000  0.00860  0.00309 -0.00263 =
 -0.00000  0.00105  0.00000
O00B  5     0.69787  0.01405  1.14548  11.00000  0.00521  0.00520  0.00187 =
 -0.00250  0.00032 -0.00607
O00C  5     0.79378  0.48784  0.84066  11.00000 -0.00160  0.00923 -0.00314 =
 0.00074 -0.00436 -0.00169
O00D  5     0.48356  0.25000  0.32109  10.50000  0.01164  0.01127 -0.00402 =
 -0.00000  0.00262  0.00000
O00E  5     0.76846  0.49552  0.45940  11.00000  0.00024  0.00879  0.00080 =
 0.00070 -0.00173 -0.00002
O00F  5     0.63087  0.25000  0.59991  10.50000  0.00565  0.03494  0.00089 =
 0.00000  0.00118  0.00000
O00G  5     0.05270  0.25000  0.62905  10.50000  0.00709  0.01459  0.00021 =
 0.00000  0.00330  0.00000
O00H  5     0.51968  0.25000  0.80584  10.50000  0.00911  0.02082  0.00011 =
 0.00000  0.00707  0.00000
O00I  5     0.92118  0.75000  1.07158  10.50000  0.00411  0.00445  0.00500 =
 0.00000  0.00632  0.00000
HKLF 4
END
EOF

     shelxl dials > shelxl.log
     cd ..
}

# Process each dataset

mkdir -p Data_1
cd Data_1
process-one Data_1 20
cd ..

mkdir -p Data_2
cd Data_2
process-one Data_2 20
cd ..

mkdir -p Data_3
cd Data_3
process-one Data_3 20
cd ..

mkdir -p Data_4
cd Data_4
process-one Data_4 20
cd ..

mkdir -p Data_5
cd Data_5
process-one Data_5 20
cd ..

# Scale, solve, and refine
mkdir -p scale
cd scale/
scale_and_solve
cd ..

