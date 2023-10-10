#!/bin/bash
  
function process-one {
  DATA=$1
  EXCLUDE_IMAGES_MULTIPLE=$2
 
  dials.import ../../$DATA/SMV/data/*.img geometry.goniometer.axis=-0.653155,-0.757051,0
  dials.generate_mask imported.expt \
      untrusted.rectangle=0,516,255,261\
      untrusted.rectangle=255,261,0,516
  dials.apply_mask imported.expt mask=pixels.mask
  dials.find_spots masked.expt\
      exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE d_max=10 d_min=0.5
  dials.index masked.expt strong.refl detector.fix=distance space_group=P2_1
  dials.refine indexed.expt indexed.refl detector.fix=distance crystal.unit_cell.force_static=True
  dials.integrate refined.expt refined.refl prediction.d_min=0.5\
      exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE
  dials.apply_mask imported.expt mask=pixels.mask
}


# Process each dataset

#  experiments = ../experiment_12/dials-proc/integrated.expt
#  experiments = ../experiment_14/dials-proc/integrated.expt
#  experiments = ../experiment_16/dials-proc/integrated.expt
#  experiments = ../experiment_19/dials-proc/integrated.expt
#  experiments = ../experiment_1/dials-proc/integrated.expt
#  experiments = ../experiment_3/dials-proc/integrated.expt
#  experiments = ../experiment_8/dials-proc/integrated.expt
  
mkdir -p experiment_1
cd experiment_1
process-one experiment_1 20
cd ..

mkdir -p experiment_3
cd experiment_3
process-one experiment_3 20
cd ..

mkdir -p experiment_8
cd experiment_8
process-one experiment_8 20
cd ..

mkdir -p experiment_12
cd experiment_12
process-one experiment_12 20
cd ..

mkdir -p experiment_14
cd experiment_14
process-one experiment_14 20
cd ..

mkdir -p experiment_16
cd experiment_16
process-one experiment_16 20
cd ..

mkdir -p experiment_19
cd experiment_19
process-one experiment_19 20
cd ..

mkdir -p solve
cd solve/
dials.cosym\
  ../experiment_12/dials-proc/integrated.{expt,refl}\
  ../experiment_14/dials-proc/integrated.{expt,refl}\
  ../experiment_16/dials-proc/integrated.{expt,refl}\
  ../experiment_19/dials-proc/integrated.{expt,refl}\
  ../experiment_1/dials-proc/integrated.{expt,refl}\
  ../experiment_3/dials-proc/integrated.{expt,refl}\
  ../experiment_8/dials-proc/integrated.{expt,refl}\
  space_group=P2_1
dials.scale symmetrized.{expt,refl}
dials.export scaled.{expt,refl} format=shelx
cat <<+ > dials.ins
TITL P2
CELL 0.0251 12.403  8.097 13.685  90.000 111.935  90.000
ZERR 1.00    0.000  0.000  0.000   0.000   0.000   0.000
LATT -1
SYMM -X,Y,-Z
SFAC C   0.7307 36.9951  1.1951 11.2966         =
         0.4563  2.8139  0.1247  0.3456  0.0000 =
         0.0000  0.0000  0.0000  0.7700 12.0107
SFAC O   0.4548 23.7803  0.9173  7.6220         =
         0.4719  2.1440  0.1384  0.2959  0.0000 =
         0.0000  0.0000  0.0000  0.7300 15.9990
SFAC H   0.3754 15.4946  0.1408  4.1261         =
         0.0216  0.0246 -0.1012 46.8840  0.0000 =
         0.0000  0.0000  0.0000  0.3200  1.0080
UNIT 26 4 36
TREF 5000
HKLF 4
END

+
shelxt dials
cd ..

