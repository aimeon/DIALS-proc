#!/bin/bash

set -x

# Check script input
if [ "$#" -ne 1 ]; then
    echo "You must supply the location of the data parent directory " \
"(containing Data{1..4}/ only"
    exit 1
fi
PARENTDIR=$(realpath "$1")

mkdir -p Data1
cd Data1
cat <<EOF > XDS.INP
MAXIMUM_NUMBER_OF_JOBS=4
MAXIMUM_NUMBER_OF_PROCESSORS=4
NAME_TEMPLATE_OF_DATA_FRAMES= $PARENTDIR/Data1/SMV/data/0????.img   SMV
DATA_RANGE=           1 513
SPOT_RANGE=           1 513
BACKGROUND_RANGE=     1 513
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
SPACE_GROUP_NUMBER= 22
UNIT_CELL_CONSTANTS=   18.8  19.1  6.8  90.0  90.0  90.0
FRIEDEL'S_LAW=TRUE
STARTING_ANGLE= -48.3500
STARTING_FRAME= 1
MAX_CELL_AXIS_ERROR=  0.05
MAX_CELL_ANGLE_ERROR= 3.0
NX=516     NY=516
QX=0.0550  QY=0.0550
OVERLOAD= 130000
TRUSTED_REGION= 0.0  1.41
SENSOR_THICKNESS=0.30
AIR=0.0
UNTRUSTED_RECTANGLE= 255 262 0 517
UNTRUSTED_RECTANGLE= 0 517 255 262
VALUE_RANGE_FOR_TRUSTED_DETECTOR_PIXELS= 10 30000
INCLUDE_RESOLUTION_RANGE= 20 0.6
DIRECTION_OF_DETECTOR_X-AXIS= 1 0 0
DIRECTION_OF_DETECTOR_Y-AXIS= 0 1 0
ORGX= 298.49    ORGY= 214.64
DETECTOR_DISTANCE= +439.48
OSCILLATION_RANGE= 0.2318
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

mkdir -p Data2
cd Data2
cat <<EOF > XDS.INP
MAXIMUM_NUMBER_OF_JOBS=4
MAXIMUM_NUMBER_OF_PROCESSORS=4
NAME_TEMPLATE_OF_DATA_FRAMES= $PARENTDIR/Data2/SMV/data/0????.img   SMV
DATA_RANGE=           1 522
SPOT_RANGE=           1 522
BACKGROUND_RANGE=     1 522
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
SPACE_GROUP_NUMBER= 22
UNIT_CELL_CONSTANTS=   18.8  19.1  6.8  90.0  90.0  90.0
FRIEDEL'S_LAW=TRUE
STARTING_ANGLE= -53.2
STARTING_FRAME= 1
MAX_CELL_AXIS_ERROR=  0.05
MAX_CELL_ANGLE_ERROR= 3.0
NX=516     NY=516
QX=0.0550  QY=0.0550
OVERLOAD= 130000
TRUSTED_REGION= 0.0  1.41
SENSOR_THICKNESS=0.30
AIR=0.0
UNTRUSTED_RECTANGLE= 255 262 0 517
UNTRUSTED_RECTANGLE= 0 517 255 262
VALUE_RANGE_FOR_TRUSTED_DETECTOR_PIXELS= 10 30000
INCLUDE_RESOLUTION_RANGE= 20 0.6
DIRECTION_OF_DETECTOR_X-AXIS= 1 0 0
DIRECTION_OF_DETECTOR_Y-AXIS= 0 1 0
ORGX= 299.12    ORGY= 208.50
DETECTOR_DISTANCE= +439.48
OSCILLATION_RANGE= 0.2318
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

mkdir -p Data3
cd Data3
cat <<EOF > XDS.INP
MAXIMUM_NUMBER_OF_JOBS=4
MAXIMUM_NUMBER_OF_PROCESSORS=4
NAME_TEMPLATE_OF_DATA_FRAMES= $PARENTDIR/Data3/SMV/data/0????.img   SMV
DATA_RANGE=           1 391
SPOT_RANGE=           1 391
BACKGROUND_RANGE=     1 391
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
SPACE_GROUP_NUMBER= 22
UNIT_CELL_CONSTANTS=   18.4  18.7  6.6  90.0  90.0  90.0
FRIEDEL'S_LAW=TRUE
STARTING_ANGLE= -53.3500
STARTING_FRAME= 1
MAX_CELL_AXIS_ERROR=  0.05
MAX_CELL_ANGLE_ERROR= 3.0
NX=516     NY=516
QX=0.0550  QY=0.0550
OVERLOAD= 130000
TRUSTED_REGION= 0.0  1.41
SENSOR_THICKNESS=0.30
AIR=0.0
UNTRUSTED_RECTANGLE= 255 262 0 517
UNTRUSTED_RECTANGLE= 0 517 255 262
VALUE_RANGE_FOR_TRUSTED_DETECTOR_PIXELS= 10 30000
INCLUDE_RESOLUTION_RANGE= 20 0.6
DIRECTION_OF_DETECTOR_X-AXIS= 1 0 0
DIRECTION_OF_DETECTOR_Y-AXIS= 0 1 0
ORGX= 293.86    ORGY= 204.03
DETECTOR_DISTANCE= +439.48
OSCILLATION_RANGE= 0.2308
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

mkdir -p Data4
cd Data4
cat <<EOF > XDS.INP
MAXIMUM_NUMBER_OF_JOBS=4
MAXIMUM_NUMBER_OF_PROCESSORS=4
NAME_TEMPLATE_OF_DATA_FRAMES= ../../Data4/SMV/data/0????.img   SMV
DATA_RANGE=           1 425
SPOT_RANGE=           1 425
BACKGROUND_RANGE=     1 425
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
SPACE_GROUP_NUMBER= 22
UNIT_CELL_CONSTANTS= 18.6  19.0  6.8  90.0  90.0  90.0
FRIEDEL'S_LAW=TRUE
STARTING_ANGLE= -27.9900
STARTING_FRAME= 1
MAX_CELL_AXIS_ERROR=  0.05
MAX_CELL_ANGLE_ERROR= 3.0
TEST_RESOLUTION_RANGE=10. 1.0
NX=516     NY=516
QX=0.0550  QY=0.0550
OVERLOAD= 130000
TRUSTED_REGION= 0.0  1.41
SENSOR_THICKNESS=0.30
AIR=0.0
UNTRUSTED_RECTANGLE= 255 262 0 517
UNTRUSTED_RECTANGLE= 0 517 255 262
VALUE_RANGE_FOR_TRUSTED_DETECTOR_PIXELS= 10 30000
INCLUDE_RESOLUTION_RANGE= 20 0.6
DIRECTION_OF_DETECTOR_X-AXIS= 1 0 0
DIRECTION_OF_DETECTOR_Y-AXIS= 0 1 0
ORGX= 294.01    ORGY= 207.02
DETECTOR_DISTANCE= +439.48
OSCILLATION_RANGE= 0.2296
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

mkdir -p scale
cd scale/
cat <<EOF > XSCALE.INP
OUTPUT_FILE=temp.ahkl
INPUT_FILE=../Data1/XDS_ASCII.HKL
INPUT_FILE=../Data3/XDS_ASCII.HKL
INPUT_FILE=../Data4/XDS_ASCII.HKL
SPACE_GROUP_NUMBER= 22
UNIT_CELL_CONSTANTS= 18.374 18.669 6.767 90 90 90
RESOLUTION_SHELLS=4 3 2 1 0.63
EOF
xscale

cat <<EOF > XDSCONV.INP
INPUT_FILE=temp.ahkl
OUTPUT_FILE=xds.hkl  SHELX
FRIEDEL'S_LAW=FALSE
EOF
xdsconv

mkdir -p solve
cd solve/
cp ../xds.hkl .
cat <<EOF > xds.ins
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
shelxt xds > shelxt.log
cd ..

mkdir -p refine
cd refine
cp ../xds.hkl .
cat <<EOF > xds.ins
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
shelxl xds > shelxl.log

cd ../..
