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
      image_range=1,3\
      panel.parallax_correction=False\
      panel.gain=3.5\
      geometry.beam.polarization_fraction=0.5\
      geometry.beam.probe=electron\
      $ROTATION_AXIS
    dials.find_spots imported.expt d_max=10

    dials.index imported.expt strong.refl detector.fix=distance space_group=Pnma
    if [ ! -f indexed.expt ]; then
        count=$((count+1))
        continue
    fi

    dials.refine indexed.expt indexed.refl detector.fix=distance unit_cell.force_static=True
    dials.plot_scan_varying_model refined.expt
    dials.sequence_to_stills refined.expt refined.refl

    dials.ssx_integrate stills.expt stills.refl mosaicity_max_limit=0.01

    # Change back to the top directory
    cd "$SCRIPTDIR"

    count=$((count+1))
done

# Merging for all integrated stills
#mkdir -p solve && cd solve
#xia2.reduce $(find "$SCRIPTDIR" \( -name "integrated_*.expt" -o -name "integrated_*.refl" \) | sort -V)
#cd "$SCRIPTDIR"
