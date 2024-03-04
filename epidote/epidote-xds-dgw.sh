#!/bin/bash

set -x

# Check script input
if [ "$#" -ne 1 ]; then
    echo "You must supply the location of the data parent directory " \
"(containing Data_{1..5}/) only"
    exit 1
fi
PARENTDIR=$(realpath "$1")

mkdir -p Data_1/
cd Data_1/
cat <<EOF > XDS.INP
MAXIMUM_NUMBER_OF_JOBS=4
MAXIMUM_NUMBER_OF_PROCESSORS=4
NAME_TEMPLATE_OF_DATA_FRAMES= $PARENTDIR/Data_1/SMV/data/0????.img   SMV
DATA_RANGE=           1 311
SPOT_RANGE=           1 311
BACKGROUND_RANGE=     1 311
EXCLUDE_DATA_RANGE=20 20
EXCLUDE_DATA_RANGE=40 40
EXCLUDE_DATA_RANGE=60 60
EXCLUDE_DATA_RANGE=80 80
EXCLUDE_DATA_RANGE=100 100
EXCLUDE_DATA_RANGE=120 120
EXCLUDE_DATA_RANGE=140 140
EXCLUDE_DATA_RANGE=160 160
EXCLUDE_DATA_RANGE=180 180
EXCLUDE_DATA_RANGE=200 200
EXCLUDE_DATA_RANGE=220 220
EXCLUDE_DATA_RANGE=240 240
EXCLUDE_DATA_RANGE=260 260
EXCLUDE_DATA_RANGE=280 280
EXCLUDE_DATA_RANGE=300 300
DELPHI=25 ! set very high to allow processing to complete
SPACE_GROUP_NUMBER= 11
UNIT_CELL_CONSTANTS= 9.035  5.795 10.397  90.000 115.659  90.000
FRIEDEL'S_LAW=TRUE
STARTING_ANGLE= -61.2300
STARTING_FRAME= 1
MAX_CELL_AXIS_ERROR=  0.05
MAX_CELL_ANGLE_ERROR= 3.0
TEST_RESOLUTION_RANGE=10. 1.0
NX=516     NY=516
QX=0.0550  QY=0.0550
OVERLOAD= 130000
TRUSTED_REGION= 0.0  1.05
SENSOR_THICKNESS=0.30
AIR=0.0
UNTRUSTED_RECTANGLE= 255 262 0 517
UNTRUSTED_RECTANGLE= 0 517 255 262
VALUE_RANGE_FOR_TRUSTED_DETECTOR_PIXELS= 10 30000
INCLUDE_RESOLUTION_RANGE= 10 0.55
DIRECTION_OF_DETECTOR_X-AXIS= 1 0 0
DIRECTION_OF_DETECTOR_Y-AXIS= 0 1 0
ORGX= 215.45    ORGY= 227.39
DETECTOR_DISTANCE= +439.48
OSCILLATION_RANGE= 0.2320
ROTATION_AXIS= -0.6204 0.7843 0.0000
X-RAY_WAVELENGTH= 0.0251
INCIDENT_BEAM_DIRECTION= 0 0 1
REFINE(IDXREF)=    BEAM AXIS ORIENTATION CELL !POSITION
REFINE(INTEGRATE)= !POSITION BEAM AXIS !ORIENTATION CELL
REFINE(CORRECT)=   BEAM AXIS ORIENTATION CELL !POSITION
MINIMUM_FRACTION_OF_INDEXED_SPOTS= 0.25
EOF
xds
cd ..

mkdir -p Data_2/
cd Data_2/
cat <<EOF > XDS.INP
MAXIMUM_NUMBER_OF_JOBS=4
MAXIMUM_NUMBER_OF_PROCESSORS=4
NAME_TEMPLATE_OF_DATA_FRAMES= $PARENTDIR/Data_2/SMV/data/0????.img   SMV
DATA_RANGE=           1 519
SPOT_RANGE=           1 519
BACKGROUND_RANGE=     1 519
EXCLUDE_DATA_RANGE=20 20
EXCLUDE_DATA_RANGE=40 40
EXCLUDE_DATA_RANGE=60 60
EXCLUDE_DATA_RANGE=80 80
EXCLUDE_DATA_RANGE=100 100
EXCLUDE_DATA_RANGE=120 120
EXCLUDE_DATA_RANGE=140 140
EXCLUDE_DATA_RANGE=160 160
EXCLUDE_DATA_RANGE=180 180
EXCLUDE_DATA_RANGE=200 200
EXCLUDE_DATA_RANGE=220 220
EXCLUDE_DATA_RANGE=240 240
EXCLUDE_DATA_RANGE=260 260
EXCLUDE_DATA_RANGE=280 280
EXCLUDE_DATA_RANGE=300 300
EXCLUDE_DATA_RANGE=320 320
EXCLUDE_DATA_RANGE=340 340
EXCLUDE_DATA_RANGE=360 360
EXCLUDE_DATA_RANGE=380 380
EXCLUDE_DATA_RANGE=400 400
EXCLUDE_DATA_RANGE=420 420
EXCLUDE_DATA_RANGE=440 440
EXCLUDE_DATA_RANGE=460 460
EXCLUDE_DATA_RANGE=480 480
EXCLUDE_DATA_RANGE=500 500
SPACE_GROUP_NUMBER= 11
UNIT_CELL_CONSTANTS= 9.035  5.795 10.397  90.000 115.659  90.000
FRIEDEL'S_LAW=TRUE
STARTING_ANGLE= -61.2300
STARTING_FRAME= 1
MAX_CELL_AXIS_ERROR=  0.05
MAX_CELL_ANGLE_ERROR= 3.0
TEST_RESOLUTION_RANGE=10. 1.0
NX=516     NY=516
QX=0.0550  QY=0.0550
OVERLOAD= 130000
TRUSTED_REGION= 0.0  1.05
SENSOR_THICKNESS=0.30
AIR=0.0
UNTRUSTED_RECTANGLE= 255 262 0 517
UNTRUSTED_RECTANGLE= 0 517 255 262
VALUE_RANGE_FOR_TRUSTED_DETECTOR_PIXELS= 10 30000
INCLUDE_RESOLUTION_RANGE= 10 0.55
DIRECTION_OF_DETECTOR_X-AXIS= 1 0 0
DIRECTION_OF_DETECTOR_Y-AXIS= 0 1 0
ORGX= 215.45    ORGY= 227.39
DETECTOR_DISTANCE= +439.48
OSCILLATION_RANGE= 0.2320
ROTATION_AXIS= -0.6204 0.7843 0.0000
X-RAY_WAVELENGTH= 0.0251
INCIDENT_BEAM_DIRECTION= 0 0 1
REFINE(IDXREF)=    BEAM AXIS ORIENTATION CELL !POSITION
REFINE(INTEGRATE)= !POSITION BEAM AXIS !ORIENTATION CELL
REFINE(CORRECT)=   BEAM AXIS ORIENTATION CELL !POSITION
MINIMUM_FRACTION_OF_INDEXED_SPOTS= 0.25
EOF
xds
cd ..

mkdir -p Data_3
cd Data_3/
cat <<EOF > XDS.INP
MAXIMUM_NUMBER_OF_JOBS=4
MAXIMUM_NUMBER_OF_PROCESSORS=4
NAME_TEMPLATE_OF_DATA_FRAMES= $PARENTDIR/Data_3/SMV/data/0????.img   SMV
DATA_RANGE=           1 530
SPOT_RANGE=           1 530
BACKGROUND_RANGE=     1 530
EXCLUDE_DATA_RANGE=20 20
EXCLUDE_DATA_RANGE=40 40
EXCLUDE_DATA_RANGE=60 60
EXCLUDE_DATA_RANGE=80 80
EXCLUDE_DATA_RANGE=100 100
EXCLUDE_DATA_RANGE=120 120
EXCLUDE_DATA_RANGE=140 140
EXCLUDE_DATA_RANGE=160 160
EXCLUDE_DATA_RANGE=180 180
EXCLUDE_DATA_RANGE=200 200
EXCLUDE_DATA_RANGE=220 220
EXCLUDE_DATA_RANGE=240 240
EXCLUDE_DATA_RANGE=260 260
EXCLUDE_DATA_RANGE=280 280
EXCLUDE_DATA_RANGE=300 300
EXCLUDE_DATA_RANGE=320 320
EXCLUDE_DATA_RANGE=340 340
EXCLUDE_DATA_RANGE=360 360
EXCLUDE_DATA_RANGE=380 380
EXCLUDE_DATA_RANGE=400 400
EXCLUDE_DATA_RANGE=420 420
EXCLUDE_DATA_RANGE=440 440
EXCLUDE_DATA_RANGE=460 460
EXCLUDE_DATA_RANGE=480 480
EXCLUDE_DATA_RANGE=500 500
EXCLUDE_DATA_RANGE=520 520
SPACE_GROUP_NUMBER= 11
UNIT_CELL_CONSTANTS= 9.035  5.795 10.397  90.000 115.659  90.000
FRIEDEL'S_LAW=TRUE
STARTING_ANGLE= -71.9900
STARTING_FRAME= 1
MAX_CELL_AXIS_ERROR=  0.05
MAX_CELL_ANGLE_ERROR= 3.0
TEST_RESOLUTION_RANGE=10. 1.0
NX=516  NY=516
QX=0.055  QY=0.055
OVERLOAD= 130000
TRUSTED_REGION= 0.0  1.05
SENSOR_THICKNESS=0.30
AIR=0.0
UNTRUSTED_RECTANGLE= 255 262 0 517
UNTRUSTED_RECTANGLE= 0 517 255 262
VALUE_RANGE_FOR_TRUSTED_DETECTOR_PIXELS= 10 30000
INCLUDE_RESOLUTION_RANGE= 10 0.55
DIRECTION_OF_DETECTOR_X-AXIS= 1 0 0
DIRECTION_OF_DETECTOR_Y-AXIS= 0 1 0
ORGX= 241.86    ORGY= 267.21
DETECTOR_DISTANCE= +439.48
OSCILLATION_RANGE= 0.2306
ROTATION_AXIS= -0.6204 0.7843 0.0000
X-RAY_WAVELENGTH= 0.0251
INCIDENT_BEAM_DIRECTION= 0 0 1
REFINE(IDXREF)=    BEAM AXIS ORIENTATION CELL !POSITION
REFINE(INTEGRATE)= !POSITION BEAM AXIS !ORIENTATION CELL
REFINE(CORRECT)=   BEAM AXIS ORIENTATION CELL !POSITION
MINIMUM_FRACTION_OF_INDEXED_SPOTS= 0.25
EOF
xds
cd ..

mkdir -p Data_4
cd Data_4/
cat <<EOF > XDS.INP
MAXIMUM_NUMBER_OF_JOBS=4
MAXIMUM_NUMBER_OF_PROCESSORS=4
NAME_TEMPLATE_OF_DATA_FRAMES= $PARENTDIR/Data_4/SMV/data/0????.img   SMV
DATA_RANGE=           1 554
SPOT_RANGE=           1 554
BACKGROUND_RANGE=     1 554
EXCLUDE_DATA_RANGE=20 20
EXCLUDE_DATA_RANGE=40 40
EXCLUDE_DATA_RANGE=60 60
EXCLUDE_DATA_RANGE=80 80
EXCLUDE_DATA_RANGE=100 100
EXCLUDE_DATA_RANGE=120 120
EXCLUDE_DATA_RANGE=140 140
EXCLUDE_DATA_RANGE=160 160
EXCLUDE_DATA_RANGE=180 180
EXCLUDE_DATA_RANGE=200 200
EXCLUDE_DATA_RANGE=220 220
EXCLUDE_DATA_RANGE=240 240
EXCLUDE_DATA_RANGE=260 260
EXCLUDE_DATA_RANGE=280 280
EXCLUDE_DATA_RANGE=300 300
EXCLUDE_DATA_RANGE=320 320
EXCLUDE_DATA_RANGE=340 340
EXCLUDE_DATA_RANGE=360 360
EXCLUDE_DATA_RANGE=380 380
EXCLUDE_DATA_RANGE=400 400
EXCLUDE_DATA_RANGE=420 420
EXCLUDE_DATA_RANGE=440 440
EXCLUDE_DATA_RANGE=460 460
EXCLUDE_DATA_RANGE=480 480
EXCLUDE_DATA_RANGE=500 500
EXCLUDE_DATA_RANGE=520 520
EXCLUDE_DATA_RANGE=540 540
SPACE_GROUP_NUMBER= 11
UNIT_CELL_CONSTANTS= 9.035  5.795 10.397  90.000 115.659  90.000
FRIEDEL'S_LAW=TRUE
STARTING_ANGLE= -61.5800
STARTING_FRAME= 1
MAX_CELL_AXIS_ERROR=  0.05
MAX_CELL_ANGLE_ERROR= 3.0
TEST_RESOLUTION_RANGE=10. 1.0
NX=516     NY=516
QX=0.0550  QY=0.0550
OVERLOAD= 130000
TRUSTED_REGION= 0.0  1.05
SENSOR_THICKNESS=0.30
AIR=0.0
UNTRUSTED_RECTANGLE= 255 262 0 517
UNTRUSTED_RECTANGLE= 0 517 255 262
VALUE_RANGE_FOR_TRUSTED_DETECTOR_PIXELS= 10 30000
INCLUDE_RESOLUTION_RANGE= 10 0.55
DIRECTION_OF_DETECTOR_X-AXIS= 1 0 0
DIRECTION_OF_DETECTOR_Y-AXIS= 0 1 0
ORGX= 213.93    ORGY= 228.12
DETECTOR_DISTANCE= +439.48
OSCILLATION_RANGE= 0.2314
ROTATION_AXIS= -0.6204 0.7843 0.0000
X-RAY_WAVELENGTH= 0.0251
INCIDENT_BEAM_DIRECTION= 0 0 1
REFINE(IDXREF)=    BEAM AXIS ORIENTATION CELL !POSITION
REFINE(INTEGRATE)= !POSITION BEAM AXIS !ORIENTATION CELL
REFINE(CORRECT)=   BEAM AXIS ORIENTATION CELL !POSITION
MINIMUM_FRACTION_OF_INDEXED_SPOTS= 0.25
EOF
xds
cd ..

mkdir -p Data_5/
cd Data_5/
cat <<EOF > XDS.INP
MAXIMUM_NUMBER_OF_JOBS=4
MAXIMUM_NUMBER_OF_PROCESSORS=4
NAME_TEMPLATE_OF_DATA_FRAMES= $PARENTDIR/Data_5/SMV/data/0????.img   SMV
DATA_RANGE=           1 465
SPOT_RANGE=           1 465
BACKGROUND_RANGE=     1 465
EXCLUDE_DATA_RANGE=20 20
EXCLUDE_DATA_RANGE=40 40
EXCLUDE_DATA_RANGE=60 60
EXCLUDE_DATA_RANGE=80 80
EXCLUDE_DATA_RANGE=100 100
EXCLUDE_DATA_RANGE=120 120
EXCLUDE_DATA_RANGE=140 140
EXCLUDE_DATA_RANGE=160 160
EXCLUDE_DATA_RANGE=180 180
EXCLUDE_DATA_RANGE=200 200
EXCLUDE_DATA_RANGE=220 220
EXCLUDE_DATA_RANGE=240 240
EXCLUDE_DATA_RANGE=260 260
EXCLUDE_DATA_RANGE=280 280
EXCLUDE_DATA_RANGE=300 300
EXCLUDE_DATA_RANGE=320 320
EXCLUDE_DATA_RANGE=340 340
EXCLUDE_DATA_RANGE=360 360
EXCLUDE_DATA_RANGE=380 380
EXCLUDE_DATA_RANGE=400 400
EXCLUDE_DATA_RANGE=420 420
EXCLUDE_DATA_RANGE=440 440
EXCLUDE_DATA_RANGE=460 460
SPACE_GROUP_NUMBER= 11
UNIT_CELL_CONSTANTS= 9.035  5.795 10.397  90.000 115.659  90.000
FRIEDEL'S_LAW=TRUE
STARTING_ANGLE= -69.36
STARTING_FRAME= 1
MAX_CELL_AXIS_ERROR=  0.05
MAX_CELL_ANGLE_ERROR= 3.0
TEST_RESOLUTION_RANGE=10. 1.0
NX=516     NY=516
QX=0.0550  QY=0.0550
OVERLOAD= 130000
TRUSTED_REGION= 0.0  1.05
SENSOR_THICKNESS=0.30
AIR=0.0
UNTRUSTED_RECTANGLE= 255 262 0 517
UNTRUSTED_RECTANGLE= 0 517 255 262
VALUE_RANGE_FOR_TRUSTED_DETECTOR_PIXELS= 10 30000
INCLUDE_RESOLUTION_RANGE= 10 0.55
DIRECTION_OF_DETECTOR_X-AXIS= 1 0 0
DIRECTION_OF_DETECTOR_Y-AXIS= 0 1 0
ORGX= 293.45    ORGY= 224.49
DETECTOR_DISTANCE= +439.48
OSCILLATION_RANGE= 0.230
ROTATION_AXIS= -0.6204 0.7843 0.0000
X-RAY_WAVELENGTH= 0.0251
INCIDENT_BEAM_DIRECTION= 0 0 1
REFINE(IDXREF)=    BEAM AXIS ORIENTATION CELL !POSITION
REFINE(INTEGRATE)= !POSITION BEAM AXIS !ORIENTATION CELL
REFINE(CORRECT)=   BEAM AXIS ORIENTATION CELL !POSITION
MINIMUM_FRACTION_OF_INDEXED_SPOTS= 0.25
EOF
xds
cd ..

# Data_1 is weak and has a poor refined cell, so let's exclude it
mkdir -p solve
cd solve/
cat <<EOF > XSCALE.INP
OUTPUT_FILE=temp.ahkl
INPUT_FILE=../Data_2/XDS_ASCII.HKL
INPUT_FILE=../Data_3/XDS_ASCII.HKL
INPUT_FILE=../Data_4/XDS_ASCII.HKL
INPUT_FILE=../Data_5/XDS_ASCII.HKL
SPACE_GROUP_NUMBER= 11
UNIT_CELL_CONSTANTS= 9.02 5.77 10.31 90 114.82 90
EOF
xscale

cat <<EOF > XDSCONV.INP
INPUT_FILE=temp.ahkl
OUTPUT_FILE=xds.hkl  SHELX
FRIEDEL'S_LAW=FALSE
EOF
xdsconv

cat <<+ > xds.ins
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

shelxt xds > shelxt.log

mkdir -p refine
cd refine
cp ../xds.hkl .
cat <<EOF > xds.ins
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

shelxl xds > shelxl.log

cd ../..
