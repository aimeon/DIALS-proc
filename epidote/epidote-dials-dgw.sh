#!/bin/bash

set -x

function process-one {
  DATA=$1
  EXCLUDE_IMAGES_MULTIPLE=$2

  dials.import ../../$DATA/SMV/data/*.img geometry.goniometer.axis=-0.639656,-0.768383,0
  dials.generate_mask imported.expt \
      untrusted.rectangle=0,516,255,261\
      untrusted.rectangle=255,261,0,516
  dials.apply_mask imported.expt mask=pixels.mask
  dials.find_spots masked.expt\
      exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE d_max=10 d_min=0.55 nproc=12
  dials.index masked.expt strong.refl detector.fix=distance space_group="P2_1/m"
  dials.refine indexed.expt indexed.refl detector.fix=distance crystal.unit_cell.force_static=True
  dials.integrate refined.expt refined.refl prediction.d_min=0.5\
      exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE nproc=12\
      profile.gaussian_rs.min_spots.per_degree=0 profile.gaussian_rs.min_spots.overall=0

  # Integrate second way, using scans split at the calibration images
  dials.slice_sequence exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE refined.expt refined.refl
  dials.integrate refined_sliced.expt refined_sliced.refl prediction.d_min=0.5\
      profile.gaussian_rs.min_spots.per_degree=0 profile.gaussian_rs.min_spots.overall=0\
      output.experiments=integrated_sliced.expt output.reflections=integrated_sliced.refl\
      output.log=dials.integrate.sliced.log nproc=12

  # Third way, refine again prior to integrating slices
  dials.refine refined_sliced.expt refined_sliced.refl\
      detector.fix=distance crystal.fix=cell\
      output.experiments=re-refined_sliced.expt output.reflections=re-refined_sliced.refl\
      output.log=dials.refine.sliced.log
  dials.integrate re-refined_sliced.expt re-refined_sliced.refl prediction.d_min=0.5\
      profile.gaussian_rs.min_spots.per_degree=0 profile.gaussian_rs.min_spots.overall=0\
      output.experiments=integrated_sliced2.expt output.reflections=integrated_sliced2.refl\
      output.log=dials.integrate.sliced2.log nproc=12
}

function scale_and_solve {
    INTEGRATED=$1
    INTENSITY_CHOICE=$2

    dials.scale\
      ../Data_1/$INTEGRATED.{expt,refl}\
      ../Data_2/$INTEGRATED.{expt,refl}\
      ../Data_3/$INTEGRATED.{expt,refl}\
      ../Data_4/$INTEGRATED.{expt,refl}\
      ../Data_5/$INTEGRATED.{expt,refl}\
      d_min=0.55 intensity_choice=$INTENSITY_CHOICE

    # Export to dials.hkl with different partiality cutoffs
    dials.export scaled.{expt,refl} format=shelx
    dials.export scaled.{expt,refl} format=shelx partiality_threshold=0.25 shelx.hklout=dials-0.25.hkl

    # Make dials.ins
    cat <<+ > dials.ins
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
+

    shelxt dials -s"P2(1)_m" > shelx.log
    cp dials.ins dials-0.25.ins
    shelxt dials-0.25 -s"P2(1)_m" > shelx-0.25.log

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


# Solve structure with various options
mkdir -p solve1
cd solve1/
scale_and_solve "integrated" "combine"
cd ..

mkdir -p solve2
cd solve2/
scale_and_solve "integrated" "profile"
cd ..

mkdir -p solve3
cd solve3/
scale_and_solve "integrated_sliced" "combine"
cd ..

mkdir -p solve4
cd solve4/
scale_and_solve "integrated_sliced" "profile"
cd ..

mkdir -p solve5
cd solve5/
scale_and_solve "integrated_sliced2" "combine"
cd ..

mkdir -p solve6
cd solve6/
scale_and_solve "integrated_sliced2" "profile"
cd ..


