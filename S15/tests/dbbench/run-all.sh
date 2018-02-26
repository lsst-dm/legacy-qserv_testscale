#!/bin/bash

set -x
set -e

DIR=$(cd "$(dirname "$0")"; pwd -P)

FILES=$(ls queries/*.ini)
DATE=$(date +"%Y%m%d-%H%M%S")
OUTDIR="$DIR/queries/out/$DATE"
OUTLINK="$DIR/queries/out/current"
rm "$OUTLINK"
ln -s "$OUTDIR" "$OUTLINK"
PORT=4040
for f in $FILES 
do
    echo "Processing $f file..."
    outfile=$(basename "$f")
    outfile=$(echo "$outfile" | sed 's/\.ini$/\.stats/')
    mkdir -p "$OUTDIR"
    dbbench --database=LSST --query-stats-file="$OUTLINK/${outfile}" \
        --username=qsmaster --host=ccqserv100 --port="$PORT" "$f"
done

