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
      panel.gain=3.5\
      panel.trusted_range=0,65535\
      geometry.beam.polarization_fraction=0.5\
      geometry.beam.probe=electron\
      $ROTATION_AXIS
    dials.find_spots imported.expt d_max=10

    dials.index imported.expt strong.refl detector.fix=distance space_group=Pnma unit_cell="20.2291 20.0053 13.5512 90.000 90.000 90.000"
    if [ ! -f indexed.expt ]; then
        cd "$SCRIPTDIR"
        count=$((count+1))
        continue
    fi

    # Try to reindex to reference dataset
    dials.reindex indexed.{expt,refl}\
      reference.experiments="$SCRIPTDIR"/data_001/indexed.expt\
      reference.reflections="$SCRIPTDIR"/data_001/indexed.refl space_group=Pnma

    dials.refine reindexed.expt reindexed.refl detector.fix=distance unit_cell.force_static=True
    dials.plot_scan_varying_model refined.expt

    # Integrate as a sequence first, for cosym later
    dials.integrate refined.expt refined.refl

    # Now integrate as a stills series
    dials.sequence_to_stills refined.expt refined.refl
    dials.ssx_integrate stills.expt stills.refl mosaicity_max_limit=0.01 ellipsoid.unit_cell.fixed=True debug.output.shoeboxes=True

    # Change back to the top directory
    cd "$SCRIPTDIR"

    count=$((count+1))
done

# Run cosym on the sweep to look for inconsistent indexing
mkdir -p cosym-sweep && cd cosym-sweep
dials.cosym\
  $(find "$SCRIPTDIR" \( -name "integrated.expt" -o -name "integrated.refl" \) | sort -V)
cd "$SCRIPTDIR"

# Merging for all integrated stills
mkdir -p solve && cd solve
xia2.ssx_reduce\
  $(find "$SCRIPTDIR" \( -name "integrated_*.expt" -o -name "integrated_*.refl" \) | sort -V)\
  d_min=0.6
dials.export DataFiles/scaled.{expt,refl} format=shelx partiality_threshold=0.25
edtools.make_shelx -c 20.2291 20.0053 13.5512 90.000 90.000 90.000 -w 0.01970 -s "Pnma" -m "Si12 O26"
mv shelx.ins dials.ins
shelxt dials
cd "$SCRIPTDIR"
