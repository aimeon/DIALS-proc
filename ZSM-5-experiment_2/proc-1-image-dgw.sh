#!/bin/bash

set -x

# Check script input
if [ "$#" -ne 2 ]; then
    echo "You must supply the location of the data parent directory " \
"(ZSM-5-experiment_2/) and the image number you want to index"
    exit 1
fi
PARENTDIR=$(realpath "$1")
IMAGENO="$2"

cat > restraint.phil <<EOF
refinement
{
  parameterisation
  {
    crystal
    {
      unit_cell
      {
        restraints
        {
          tie_to_target
          {
            values=20.2291,20.0053,13.5512,90.000,90.000,90.000
            sigmas=0.1,0.1,0.1,0.1,0.1,0.1
          }
        }
      }
    }
  }
}
EOF


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

    # Tilt series indexing for comparison
    #dials.import template="$DATADIR"/#####.img\
    #  panel.parallax_correction=False\
    #  panel.gain=7\
    #  panel.trusted_range=0,65535\
    #  geometry.beam.polarization_fraction=0.5\
    #  geometry.beam.probe=electron\
    #  $ROTATION_AXIS
    #dials.find_spots imported.expt d_max=10 gain=0.5
    #
    #dials.index imported.expt strong.refl detector.fix=distance space_group=Pnma unit_cell="20.2291 20.0053 13.5512 90.000 90.000 90.000"
    #if [ ! -f indexed.expt ]; then
    #    cd "$SCRIPTDIR"
    #    count=$((count+1))
    #    continue
    #fi

    # Now single image indexing
    dials.import template="$DATADIR"/#####.img\
      image_range="$IMAGENO","$IMAGENO"\
      panel.parallax_correction=False\
      panel.gain=3.5\
      geometry.beam.polarization_fraction=0.5\
      geometry.beam.probe=electron\
      $ROTATION_AXIS
    dials.find_spots imported.expt d_max=10

    dials.index imported.expt strong.refl detector.fix=distance space_group=Pnma unit_cell="20.2291 20.0053 13.5512 90.000 90.000 90.000"\
      indexing.method=real_space_grid_search stills.indexer=sequences output.experiments=indexed_rsgs.expt output.reflections=indexed_rsgs.refl\
      output.log=dials.index.rsgs.log ../restraint.phil 2>dials.index.rsgs.err

    dials.compare_orientation_matrices ../../image_001/"$PROCDIR"/indexed.expt indexed_rsgs.expt hkl=1,0,0 > compare_rsgs.log

    dials.index imported.expt strong.refl detector.fix=distance space_group=Pnma unit_cell="20.2291 20.0053 13.5512 90.000 90.000 90.000"\
      indexing.method=low_res_spot_match stills.indexer=sequences n_macro_cycles=2 output.experiments=indexed_lrsm.expt output.reflections=indexed_lrsm.refl\
      output.log=dials.index.lrsm.log ../restraint.phil 2>dials.index.lrsm.err

    dials.compare_orientation_matrices ../../image_001/"$PROCDIR"/indexed.expt indexed_lrsm.expt hkl=1,0,0 > compare_lrsm.log

    # Change back to the top directory
    cd "$SCRIPTDIR"

    count=$((count+1))
done

