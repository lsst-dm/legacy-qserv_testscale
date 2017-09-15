#!/bin/bash

set -x
set -e

FILES=$(ls queries/*.ini)
OUTDIR="queries/out"
for f in $FILES 
do
    echo "Processing $f file..."
    outfile=$(basename "$f")
    outfile=$(echo "$outfile" | sed 's/\.ini$/\.stats/')
    mkdir -p "$OUTDIR"
    dbbench --database=LSST --query-stats-file="$OUTDIR/${outfile}" --username=qsmaster --host=ccqserv100 --port=4040 "$f" 
done

