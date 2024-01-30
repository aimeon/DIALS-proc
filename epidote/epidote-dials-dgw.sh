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
  dials.integrate refined.expt refined.refl prediction.d_min=0.55\
      exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE nproc=12\
      profile.gaussian_rs.min_spots.per_degree=0 profile.gaussian_rs.min_spots.overall=0

  # Integrate second way, using scans split at the calibration images
  dials.slice_sequence exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE refined.expt refined.refl
  dials.integrate refined_sliced.expt refined_sliced.refl prediction.d_min=0.55\
      profile.gaussian_rs.min_spots.per_degree=0 profile.gaussian_rs.min_spots.overall=0\
      output.experiments=integrated_sliced.expt output.reflections=integrated_sliced.refl\
      output.log=dials.integrate.sliced.log nproc=12

  ## Third way, refine again prior to integrating slices.
  ## Turns out to be fragile, so commenting out!
  ## This fails for Data_5 with zero reflections for refinement for one of the slices
  #dials.refine refined_sliced.expt refined_sliced.refl\
  #    detector.fix=distance crystal.fix=cell\
  #    output.experiments=re-refined_sliced.expt output.reflections=re-refined_sliced.refl\
  #    output.log=dials.refine.sliced.log
  ## This fails for Data_1 and Data_4 with: Something went wrong. Zero pixels selected for estimation of profile parameters.
  #dials.integrate re-refined_sliced.expt re-refined_sliced.refl prediction.d_min=0.5\
  #    profile.gaussian_rs.min_spots.per_degree=0 profile.gaussian_rs.min_spots.overall=0\
  #    output.experiments=integrated_sliced2.expt output.reflections=integrated_sliced2.refl\
  #    output.log=dials.integrate.sliced2.log nproc=12
}

function scale_and_solve {
    INTEGRATED=$1
    INTENSITY_CHOICE=$2

    # Omit Data_1 because it is weak
    dials.scale\
      ../Data_2/$INTEGRATED.{expt,refl}\
      ../Data_3/$INTEGRATED.{expt,refl}\
      ../Data_4/$INTEGRATED.{expt,refl}\
      ../Data_5/$INTEGRATED.{expt,refl}\
      d_min=0.55 intensity_choice=$INTENSITY_CHOICE\
      best_unit_cell="9.00      5.83     10.34  90.000 114.921  90.000" # taken from XSCALE.LP, so merging stats are comparable with XDS

    # Get cluster information
    xia2.cluster_analysis scaled.expt scaled.refl

    # Export to dials.hkl
    dials.export scaled.{expt,refl} format=shelx

    # Make dials.ins based on Angelina's xds_a.res
    cat <<EOF > dials.ins
TITL dials in P2(1)/m
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
# R1 =  0.2241 for   2847 unique reflections after merging for Fourier
cd ..

mkdir -p solve2
cd solve2/
scale_and_solve "integrated" "profile"
# R1 =  0.2249 for   2846 unique reflections after merging for Fourier
cd ..

mkdir -p solve3
cd solve3/
scale_and_solve "integrated_sliced" "combine"
# R1 =  0.2226 for   2844 unique reflections after merging for Fourier
cd ..

mkdir -p solve4
cd solve4/
scale_and_solve "integrated_sliced" "profile"
# R1 =  0.2304 for   2817 unique reflections after merging for Fourier
cd ..

# The below jobs fail, because of failures to process in Data_1, Data_4 and Data_5
#mkdir -p solve5
#cd solve5/
#scale_and_solve "integrated_sliced2" "combine"
#cd ..
#
#mkdir -p solve6
#cd solve6/
#scale_and_solve "integrated_sliced2" "profile"
#cd ..


