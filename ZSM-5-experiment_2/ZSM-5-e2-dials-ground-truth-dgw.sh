#!/bin/bash

set -x

# Check script input
if [ "$#" -ne 1 ]; then
    echo "You must supply the location of the data parent directory " \
"(ZSM-5-experiment_2/) only"
    exit 1
fi
PARENTDIR=$(realpath "$1")

# Loop over all ground truth files
SCRIPTDIR=$(pwd)
count=1
for REINDEXED in \
"$PARENTDIR"/0_stagepos_0002/crystal_0002/SMV/reindexed.expt  \
"$PARENTDIR"/0_stagepos_0001/crystal_0001/SMV/reindexed.expt  \
"$PARENTDIR"/0_stagepos_0002/crystal_0001/SMV/reindexed.expt  \
"$PARENTDIR"/0_stagepos_0003/crystal_0002/SMV/reindexed.expt  \
"$PARENTDIR"/0_stagepos_0003/crystal_0003/SMV/reindexed.expt  \
"$PARENTDIR"/0_stagepos_0003/crystal_0004/SMV/reindexed.expt  \
"$PARENTDIR"/0_stagepos_0003/crystal_0005/SMV/reindexed.expt  \
"$PARENTDIR"/0_stagepos_0003/crystal_0006/SMV/reindexed.expt  \
"$PARENTDIR"/10_stagepos_0030/crystal_0002/SMV/reindexed.expt \
"$PARENTDIR"/10_stagepos_0030/crystal_0003/SMV/reindexed.expt \
"$PARENTDIR"/10_stagepos_0030/crystal_0004/SMV/reindexed.expt \
"$PARENTDIR"/10_stagepos_0031/crystal_0000/SMV/reindexed.expt \
"$PARENTDIR"/12_stagepos_0032/crystal_0001/SMV/reindexed.expt \
"$PARENTDIR"/2_stagepos_0006/crystal_0001/SMV/reindexed.expt  \
"$PARENTDIR"/2_stagepos_0006/crystal_0002/SMV/reindexed.expt  \
"$PARENTDIR"/2_stagepos_0007/crystal_0000/SMV/reindexed.expt  \
"$PARENTDIR"/3_stagepos_0008/crystal_0001/SMV/reindexed.expt  \
"$PARENTDIR"/3_stagepos_0010/crystal_0000/SMV/reindexed.expt  \
"$PARENTDIR"/4_stagepos_0013/crystal_0000/SMV/reindexed.expt  \
"$PARENTDIR"/7_stagepos_0017/crystal_0000/SMV/reindexed.expt  \
"$PARENTDIR"/8_stagepos_0020/crystal_0002/SMV/reindexed.expt  \
"$PARENTDIR"/8_stagepos_0021/crystal_0000/SMV/reindexed.expt  \
"$PARENTDIR"/8_stagepos_0021/crystal_0001/SMV/reindexed.expt  \
"$PARENTDIR"/8_stagepos_0022/crystal_0000/SMV/reindexed.expt  \
"$PARENTDIR"/8_stagepos_0022/crystal_0001/SMV/reindexed.expt  \
"$PARENTDIR"/8_stagepos_0023/crystal_0000/SMV/reindexed.expt  \
"$PARENTDIR"/8_stagepos_0023/crystal_0002/SMV/reindexed.expt  \
"$PARENTDIR"/8_stagepos_0023/crystal_0003/SMV/reindexed.expt  \
"$PARENTDIR"/9_stagepos_0024/crystal_0000/SMV/reindexed.expt  \
"$PARENTDIR"/9_stagepos_0024/crystal_0001/SMV/reindexed.expt  \
"$PARENTDIR"/9_stagepos_0027/crystal_0001/SMV/reindexed.expt  \
"$PARENTDIR"/9_stagepos_0027/crystal_0003/SMV/reindexed.expt
do
    DATADIR=${REINDEXED%"/reindexed.expt"}/data
    PROCDIR="data_"$(printf %03d $count)
    mkdir -p "$PROCDIR" && cd $PROCDIR

    # Do processing
    echo -e "Processing data in  $(realpath $DATADIR)\n" > datadir.txt

    ROTATION_AXIS=$(grep "rotation_axis=" "$DATADIR"/../dials_variables.sh | cut -d "'" -f2)
    echo $ROTATION_AXIS

    dials.import template="$DATADIR"/#####.img\
      panel.parallax_correction=False\
      panel.gain=7\
      panel.trusted_range=0,65535\
      geometry.beam.polarization_fraction=0.5\
      geometry.beam.probe=electron\
      $ROTATION_AXIS
    dials.find_spots imported.expt d_max=10 gain=0.5

    dials.index imported.expt strong.refl detector.fix=distance unit_cell="20.2291 20.0053 13.5512 90.000 90.000 90.000"
    if [ ! -f indexed.expt ]; then
        cd "$SCRIPTDIR"
        count=$((count+1))
        continue
    fi

    # Check orientation
    dials.compare_orientation_matrices indexed.expt "$REINDEXED"

    # Try to reindex to reference dataset
    dials.reindex indexed.{expt,refl}\
      reference.experiments="$REINDEXED" reference.reflections=${REINDEXED%".expt"}.refl

    dials.refine reindexed.expt reindexed.refl detector.fix=distance unit_cell.force_static=True
    dials.plot_scan_varying_model refined.expt

    # Integrate as a sequence first, for cosym
    dials.integrate refined.expt refined.refl

    # Now integrate as a stills series
    dials.sequence_to_stills refined.expt refined.refl
    dials.ssx_integrate stills.expt stills.refl mosaicity_max_limit=0.01 ellipsoid.unit_cell.fixed=True debug.output.shoeboxes=True

    # Change back to the top directory
    cd "$SCRIPTDIR"

    count=$((count+1))
done

# Merging for all integrated stills - do not reindex again
mkdir -p solve && cd solve
xia2.ssx_reduce\
  $(find "$SCRIPTDIR" \( -name "integrated_*.expt" -o -name "integrated_*.refl" \) | sort -V)\
  d_min=0.6 lattice_symmetry_max_delta=0
dials.export DataFiles/scaled.{expt,refl} format=shelx partiality_threshold=0.25
edtools.make_shelx -c 20.2291 20.0053 13.5512 90.000 90.000 90.000 -w 0.01970 -s "Pnma" -m "Si92 O184"
mv shelx.ins dials.ins
shelxt dials > shelx.log
cd "$SCRIPTDIR"

# Merging for all integrated stills - force space group, but do not reindex again
mkdir -p solve_sg && cd solve_sg
dials.reindex\
  $(find "$SCRIPTDIR" \( -name "integrated_*.expt" -o -name "integrated_*.refl" \) | sort -V)\
  space_group=Pnma
xia2.ssx_reduce reindexed.expt reindexed.refl\
  d_min=0.6 lattice_symmetry_max_delta=0
dials.export DataFiles/scaled.{expt,refl} format=shelx partiality_threshold=0.25
edtools.make_shelx -c 20.2291 20.0053 13.5512 90.000 90.000 90.000 -w 0.01970 -s "Pnma" -m "Si92 O184"
mv shelx.ins dials.ins
shelxt dials > shelx.log
cd "$SCRIPTDIR"

# Run cosym on the sweeps to look for inconsistent indexing - should be none now! But there are 4
mkdir -p cosym-sweep && cd cosym-sweep
COSYMDIR=$(pwd)
dials.cosym\
  $(find "$SCRIPTDIR" \( -name "integrated.expt" -o -name "integrated.refl" \) | sort -V)

# Put the cell back in the order we want
dials.reindex symmetrized.{expt,refl} change_of_basis_op=c,b,-a space_group=Pnma

# Split the experiments
dials.split_experiments reindexed.{expt,refl}

# Loop over data sets and process again, now starting from the lattice from cosym
for EXPT in split_*.expt
do
    PROCDIR=$(basename "$EXPT" .expt)
    REFL="$PROCDIR".refl
    mkdir -p "$PROCDIR" && cd $PROCDIR

    dials.find_spots ../"$EXPT" d_max=10 gain=0.5
    dials.index ../"$EXPT" strong.refl detector.fix=distance
    dials.refine indexed.expt indexed.refl detector.fix=distance unit_cell.force_static=True
    dials.plot_scan_varying_model refined.expt
    dials.sequence_to_stills refined.expt refined.refl
    dials.ssx_integrate stills.expt stills.refl mosaicity_max_limit=0.01 ellipsoid.unit_cell.fixed=True debug.output.shoeboxes=True

    cd "$COSYMDIR"
done

mkdir -p solve && cd solve
xia2.ssx_reduce\
  $(find "$COSYMDIR" \( -name "integrated_*.expt" -o -name "integrated_*.refl" \) | sort -V)\
  d_min=0.6 lattice_symmetry_max_delta=0
dials.export DataFiles/scaled.{expt,refl} format=shelx partiality_threshold=0.25
edtools.make_shelx -c 20.2291 20.0053 13.5512 90.000 90.000 90.000 -w 0.01970 -s "Pnma" -m "Si92 O184"
mv shelx.ins dials.ins
shelxt dials > shelx.log
cd "$COSYMDIR"

mkdir -p solve_sg && cd solve_sg
dials.reindex\
  $(find "$COSYMDIR" \( -name "integrated_*.expt" -o -name "integrated_*.refl" \) | sort -V)\
  change_of_basis_op=c,b,-a space_group=Pnma
xia2.ssx_reduce reindexed.expt reindexed.refl\
  d_min=0.6 lattice_symmetry_max_delta=0
dials.export DataFiles/scaled.{expt,refl} format=shelx partiality_threshold=0.25
edtools.make_shelx -c 20.2291 20.0053 13.5512 90.000 90.000 90.000 -w 0.01970 -s "Pnma" -m "Si92 O184"
mv shelx.ins dials.ins
shelxt dials > shelx.log

cd "$SCRIPTDIR"


