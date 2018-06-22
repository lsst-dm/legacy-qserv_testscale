#!/bin/bash

set -x
set -e

DIR=$(cd "$(dirname "$0")"; pwd -P)

HOST=ccqserv126
PORT=30040

FILES=$(ls queries/*.ini)
DATE=$(date +"%Y%m%d-%H%M%S")
OUTDIR="$DIR/queries/out/$DATE"
OUTLINK="$DIR/queries/out/current"
rm "$OUTLINK"
ln -s "$OUTDIR" "$OUTLINK"
for f in $FILES 
do
    echo "Processing $f file..."
    outfile=$(basename "$f")
    outfile=$(echo "$outfile" | sed 's/\.ini$/\.stats/')
    mkdir -p "$OUTDIR"
    dbbench --database=LSST --query-stats-file="$OUTLINK/${outfile}" \
        --username=qsmaster --host="$HOST" --port="$PORT" "$f"
done

