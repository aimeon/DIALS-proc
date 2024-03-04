#!/bin/bash

function process-one {
  DATA=$1
  EXCLUDE_IMAGES_MULTIPLE=$2

  dials.import ../../$DATA/SMV/data/*.img geometry.goniometer.axis=-0.6204,-0.7843,0.0000
  dials.generate_mask imported.expt \
      untrusted.rectangle=0,516,255,261\
      untrusted.rectangle=255,261,0,516
  dials.apply_mask imported.expt mask=pixels.mask
  dials.find_spots masked.expt\
      exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE d_max=10 d_min=0.8 nproc=12
  dials.index masked.expt strong.refl detector.fix=distance space_group=P21
  dials.refine indexed.expt indexed.refl detector.fix=distance crystal.unit_cell.force_static=True
  dials.integrate refined.expt refined.refl prediction.d_min=0.8\
      exclude_images_multiple=$EXCLUDE_IMAGES_MULTIPLE nproc=12
}

function scale_and_solve {
    INTENSITY_CHOICE=$1

    dials.scale\
      ../experiment_1/integrated.{expt,refl}\
      ../experiment_3/integrated.{expt,refl}\
      ../experiment_8/integrated.{expt,refl}\
      ../experiment_12/integrated.{expt,refl}\
      ../experiment_14/integrated.{expt,refl}\
      ../experiment_16/integrated.{expt,refl}\
      ../experiment_18/integrated.{expt,refl}\
      ../experiment_19/integrated.{expt,refl}\
      filtering.method=deltacchalf\
      max_percent_removed=30\
      deltacchalf.mode=image_group\
      deltacchalf.stdcutoff=1\
      intensity_choice=$INTENSITY_CHOICE\
      d_min=0.85

    # Get cell and intensity cluster information
    dials.cluster_unit_cell scaled.expt > dials.cluster_unit_cell.log
    xia2.cluster_analysis scaled.expt scaled.refl

    dials.export scaled.{expt,refl} format=shelx

    mkdir -p solve
    cd solve
    cp ../dials.hkl .
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
    shelxt dials > shelxt.log
    cd ..

    mkdir -p refine
    cd refine
    cp ../dials.hkl .
    cat <<EOF > dials.ins
TITL ibuprofen in P2(1)
CELL 0.0251 12.403 8.097 13.685 90 111.935 90
ZERR 1 0 0 0 0 0 0
LATT -1
SYMM -X,0.5+Y,-Z
SFAC  C 0.136 0.373 0.548 3.281 1.227 13.046 0.597 41.02 0 0 0 0 0.75 12.011
SFAC  O 0.143 0.305 0.51 2.268 0.937 8.262 0.392 25.665 0 0 0 0 0.63 15.999
SFAC  H 0.037 0.561 0.127 3.791 0.236 13.556 0.129 37.723 0 0 0 0 0.32 1.008
UNIT 26 4 36
L.S. 10
PLAN  8
CONF
BOND
LIST 6
fmap 2
MORE -1
BOND \$H
WGHT 0.1861
FVAR 1.14089
C001  1     0.09163  0.08779  0.27765  11.00000  0.04420
AFIX 43
H001  3     0.04403  0.11878  0.20975  11.00000 -1.20000
AFIX 0
C002  1     0.23901 -0.08290  0.39564  11.00000  0.03554
AFIX 43
H002  3     0.29134 -0.17004  0.40839  11.00000 -1.20000
AFIX 0
C003  1     0.16513 -0.05033  0.28900  11.00000  0.04149
O004  2     0.23153  0.49557  0.54625  11.00000  0.06888
C005  1     0.68865  0.82264  0.90144  11.00000  0.06109
AFIX 43
H005  3     0.73539  0.73020  0.90818  11.00000 -1.20000
AFIX 0
C006  1     0.63634  1.13711  1.08926  11.00000  0.05773
AFIX 23
H00A  3     0.56335  1.19140  1.07959  11.00000 -1.20000
H00B  3     0.65026  1.05485  1.14415  11.00000 -1.20000
AFIX 0
C007  1     0.15997  0.13965  0.46904  11.00000  0.04720
O008  2     0.34954  0.32929  0.66771  11.00000  0.06133
C009  1     0.23775  0.00303  0.47748  11.00000  0.04603
AFIX 43
H009  3     0.28986 -0.02621  0.54411  11.00000 -1.20000
AFIX 0
C00A  1     0.51294  0.66422  0.66687  11.00000  0.05552
C00B  1     0.55220  1.02620  0.78931  11.00000  0.06026
AFIX 43
H00C  3     0.50849  1.06887  0.72322  11.00000 -1.20000
AFIX 0
C00C  1     0.17162 -0.14410  0.19472  11.00000  0.04109
AFIX 23
H00Q  3     0.24288 -0.20802  0.21669  11.00000 -1.20000
H00R  3     0.17307 -0.06607  0.14144  11.00000 -1.20000
AFIX 0
C00D  1     0.08543  0.18360  0.36385  11.00000  0.04998
AFIX 43
H00T  3     0.03426  0.27207  0.35170  11.00000 -1.20000
AFIX 0
O00E  2     0.53729  0.52247  0.72516  11.00000  0.06941
AFIX 147
H00E  3     0.48856  0.45204  0.69541  11.00000 -1.50000
AFIX 0
C00F  1     0.06283 -0.26464  0.14584  11.00000  0.04350
AFIX 13
H00U  3    -0.00704 -0.20134  0.13875  11.00000 -1.20000
AFIX 0
C00G  1     0.71765  1.41425  1.05362  11.00000  0.05471
AFIX 137
H00D  3     0.71835  1.37934  0.98682  11.00000 -1.50000
H00F  3     0.78002  1.49080  1.08571  11.00000 -1.50000
H00G  3     0.64486  1.46690  1.04331  11.00000 -1.50000
AFIX 0
C00H  1     0.05126 -0.31844  0.03775  11.00000  0.05684
AFIX 137
H00V  3     0.04163 -0.22323 -0.00652  11.00000 -1.50000
H00W  3    -0.01521 -0.38926  0.00872  11.00000 -1.50000
H00X  3     0.11994 -0.37735  0.04172  11.00000 -1.50000
AFIX 0
C00I  1     0.61777  0.88293  0.79636  11.00000  0.04537
C00J  1     0.25493  0.35858  0.59626  11.00000  0.06024
C00K  1     0.68762  0.89763  0.98796  11.00000  0.05061
AFIX 43
H00K  3     0.72938  0.85019  1.05307  11.00000 -1.20000
AFIX 0
C00L  1     0.61256  0.78688  0.69594  11.00000  0.05537
AFIX 13
H00L  3     0.68503  0.72438  0.71355  11.00000 -1.20000
AFIX 0
C00M  1     0.07312 -0.41029  0.22543  11.00000  0.06196
AFIX 137
H00Y  3     0.12336 -0.49438  0.21673  11.00000 -1.50000
H     3    -0.00251 -0.45618  0.21173  11.00000 -1.50000
HA    3     0.10475 -0.36891  0.29626  11.00000 -1.50000
AFIX 0
C00N  1     0.15232  0.22707  0.56072  11.00000  0.05965
AFIX 13
H00Z  3     0.17225  0.14533  0.61755  11.00000 -1.20000
AFIX 0
C00O  1     0.73315  1.26397  1.12538  11.00000  0.05454
AFIX 13
H00O  3     0.80450  1.20795  1.12876  11.00000 -1.20000
AFIX 0
O00P  2     0.41038  0.69180  0.60068  11.00000  0.06546
C00Q  1     0.59970  0.89955  0.60105  11.00000  0.06412
AFIX 137
H00H  3     0.58676  0.83280  0.53972  11.00000 -1.50000
H00I  3     0.66941  0.96312  0.61617  11.00000 -1.50000
H00J  3     0.53495  0.97269  0.58832  11.00000 -1.50000
AFIX 0
C00R  1     0.03403  0.30016  0.55156  11.00000  0.07733
AFIX 137
H00   3     0.01022  0.38185  0.49677  11.00000 -1.50000
HB    3     0.04124  0.35041  0.61725  11.00000 -1.50000
HC    3    -0.02297  0.21369  0.53497  11.00000 -1.50000
AFIX 0
C00S  1     0.55068  1.11075  0.88355  11.00000  0.05496
AFIX 43
H00S  3     0.50312  1.20195  0.87781  11.00000 -1.20000
AFIX 0
C00T  1     0.62484  1.04886  0.98540  11.00000  0.04342
C00U  1     0.75447  1.32844  1.24107  11.00000  0.07305
AFIX 137
H00M  3     0.68683  1.38668  1.24053  11.00000 -1.50000
H00N  3     0.82025  1.40137  1.26411  11.00000 -1.50000
H00P  3     0.76918  1.23613  1.28830  11.00000 -1.50000
AFIX 0
HKLF 4
END
EOF

    shelxl dials > shelxl.log
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

# Solve structure with different intensity choices for scaling
mkdir -p solve1
cd solve1/
scale_and_solve "combine"

cd ..
mkdir -p solve2
cd solve2/
scale_and_solve "profile"


