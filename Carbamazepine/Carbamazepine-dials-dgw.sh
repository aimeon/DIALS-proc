#!/bin/bash

set -x

# Check script input
if [ "$#" -ne 1 ]; then
    echo "You must supply the location of the data parent directory " \
"(Carbamazepine/) only"
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

    # Most data sets are 1 lattice, but some have 2 and a few even have 3. So look for up to 3.
    dials.index imported.expt strong.refl detector.fix=distance space_group="P21/n" unit_cell="7.68 11.44 13.92 90 91.22 90" max_lattices=3
    if [ ! -f indexed.expt ]; then
        cd "$SCRIPTDIR"
        count=$((count+1))
        continue
    fi

    dials.refine indexed.expt indexed.refl detector.fix=distance unit_cell.force_static=True
    dials.plot_scan_varying_model refined.expt

    # Integrate as a sequence first, for cosym later
    #dials.integrate refined.expt refined.refl

    # Now integrate as a stills series
    dials.sequence_to_stills refined.expt refined.refl
    dials.ssx_integrate stills.expt stills.refl mosaicity_max_limit=0.02\
      ellipsoid.unit_cell.fixed=True debug.output.shoeboxes=True\
      ellipsoid.refinement.min_n_reflections=8\
      ellipsoid.refinement.max_separation=4\
      ellipsoid.refinement.outlier_probability=0.99

    # Change back to the top directory
    cd "$SCRIPTDIR"

    count=$((count+1))
done

# Merging for all integrated stills
mkdir -p solve && cd solve
xia2.ssx_reduce\
  $(find "$SCRIPTDIR" \( -name "integrated_*.expt" -o -name "integrated_*.refl" \) | sort -V)\
  d_min=0.9
dials.export DataFiles/scaled.{expt,refl} format=shelx partiality_threshold=0.25
edtools.make_shelx -c 7.68 11.44 13.92 90 91.22 90 -w 0.01970 -s "P21/n " -m "C15 H12 N2 O"
mv shelx.ins dials.ins
shelxt dials > shelx.log
cd "$SCRIPTDIR"
