#!/bin/bash

set -x


mkdir -p solve_5
cd solve_5/
dials.cosym\
  ../Data_1/integrated.{expt,refl}\
  ../Data_2/integrated.{expt,refl}\
  ../Data_3/integrated.{expt,refl}\
  ../Data_4/integrated.{expt,refl}\
  ../Data_5/integrated.{expt,refl}\
  space_group="P2_1/m"
dials.reindex symmetrized.expt space_group="P2_1/m"


dials.scale reindexed.expt symmetrized.refl d_min=0.55
dials.export scaled.{expt,refl} format=shelx
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
shelxt dials -s"P2(1)_m"
cd ..

