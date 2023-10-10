#!/bin/bash

DATA1=Data1_Lei
DATA3=Data3
DATA4=Data4

cd $DATA1/
dials.import ../../$DATA1/SMV/data/*.img geometry.goniometer.axis=-0.64145,-0.767165,0
dials.generate_mask imported.expt \
    untrusted.rectangle=0,516,255,261\
    untrusted.rectangle=255,261,0,516
dials.apply_mask imported.expt mask=pixels.mask
dials.find_spots masked.expt\
  exclude_images=20:20,40:40,60:60,80:80,100:100,120:120,140:140,160:160,180:180,200:200,220:220,240:240,260:260,280:280,300:300,320:320,340:340,360:360,380:380,400:400,420:420,440:440,460:460,480:480,500:500\
  d_max=10 d_min=0.656
dials.index masked.expt strong.refl detector.fix=distance space_group=F222
dials.refine indexed.expt indexed.refl detector.fix=distance
dials.integrate refined.expt refined.refl prediction.d_min=0.656\
  exclude_images=20:20,40:40,60:60,80:80,100:100,120:120,140:140,160:160,180:180,200:200,220:220,240:240,260:260,280:280,300:300,320:320,340:340,360:360,380:380,400:400,420:420,440:440,460:460,480:480,500:500\
  nproc=12
cd ..

cd $DATA3/
dials.import ../../$DATA3/SMV/data/*.img geometry.goniometer.axis=-0.64145,-0.767165,0
dials.generate_mask imported.expt \
    untrusted.rectangle=0,516,255,261\
    untrusted.rectangle=255,261,0,516
dials.apply_mask imported.expt mask=pixels.mask
dials.find_spots masked.expt\
  exclude_images=20:20,40:40,60:60,80:80,100:100,120:120,140:140,160:160,180:180,200:200,220:220,240:240,260:260,280:280,300:300,320:320,340:340,360:360,380:380\
  d_max=10 d_min=0.632
dials.index masked.expt strong.refl detector.fix=distance space_group=F222
dials.refine indexed.expt indexed.refl detector.fix=distance
dials.integrate refined.expt refined.refl prediction.d_min=0.632\
  exclude_images=20:20,40:40,60:60,80:80,100:100,120:120,140:140,160:160,180:180,200:200,220:220,240:240,260:260,280:280,300:300,320:320,340:340,360:360,380:380\
  nproc=12
cd ..

cd $DATA4/
dials.import ../../$DATA4/SMV/data/*.img geometry.goniometer.axis=-0.64145,-0.767165,0 image_range=1,425
dials.generate_mask imported.expt \
    untrusted.rectangle=0,516,255,261\
    untrusted.rectangle=255,261,0,516
dials.apply_mask imported.expt mask=pixels.mask
dials.find_spots masked.expt\
  exclude_images=20:20,40:40,60:60,80:80,100:100,120:120,140:140,160:160,180:180,200:200,220:220,240:240,260:260,280:280,300:300,320:320,340:340,360:360,380:380,400:400,420:420\
  d_max=10 d_min=0.6
dials.index masked.expt strong.refl detector.fix=distance space_group=F222
dials.refine indexed.expt indexed.refl detector.fix=distance
dials.integrate refined.expt refined.refl prediction.d_min=0.6\
  exclude_images=20:20,40:40,60:60,80:80,100:100,120:120,140:140,160:160,180:180,200:200,220:220,240:240,260:260,280:280,300:300,320:320,340:340,360:360,380:380,400:400,420:420\
  nproc=12
cd ..

cd solve/
dials.cosym ../$DATA1/integrated.{expt,refl}\
  ../$DATA3/integrated.{expt,refl}\
  ../$DATA4/integrated.{expt,refl}\
  space_group=F222
dials.scale symmetrized.{expt,refl}
dials.export scaled.{expt,refl} format=shelx
cat <<+ > dials.ins
TITL F222
CELL 0.0251  6.770 18.890 19.040  90.000  90.000  90.000
ZERR 1.00    0.000  0.000  0.000   0.000   0.000   0.000
LATT -4
SYMM X,-Y,-Z
SYMM -X,Y,-Z
SYMM -X,-Y,Z
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
+
shelxt dials
cd ..
