#!/bin/bash

set -x

# Check script input
if [ "$#" -ne 1 ]; then
    echo "You must supply the location of the data parent directory " \
"(ZSM-5-experiment_2/) only"
    exit 1
fi
PARENTDIR=$(realpath "$1")

# Loop over all SMV/data directories
SCRIPTDIR=$(pwd)
count=1
for DATADIR in $(find $PARENTDIR -type d -path '*/SMV/data' | sort -V)
do
    PROCDIR="data_"$(printf %03d $count)
    mkdir -p "$PROCDIR" && cd $PROCDIR

    # Do processing
    echo -e "Processing data in  $(realpath $DATADIR)\n" > datadir.txt

    ROTATION_AXIS=$(grep "rotation_axis=" "$DATADIR"/../dials_variables.sh | cut -d "'" -f2)
    echo $ROTATION_AXIS

    dials.import template="$DATADIR"/#####.img\
      panel.parallax_correction=False\
      panel.gain=1\
      geometry.beam.polarization_fraction=0.5\
      geometry.beam.probe=electron\
      $ROTATION_AXIS
    dials.find_spots imported.expt

    dials.index imported.expt strong.refl detector.fix=distance
    if [ ! -f indexed.expt ]; then
        continue
    fi

    dials.refine indexed.expt indexed.refl detector.fix=distance
    dials.sequence_to_stills refined.expt refined.refl
    #dials.ssx_integrate stills.expt stills.refl

    # Change back to the top directory
    cd "$SCRIPTDIR"

    count=$((count+1))
done
