#!/bin/bash

set -x
set -e

FILES=$(ls queries/*.ini)
for f in $FILES 
do
    echo "Processing $f file..."
    outfile=$(basename "$f")
    outfile=$(echo "$outfile" | sed 's/\.ini$/\.stats/')
    dbbench --database=LSST --query-stats-file="queries/out/${outfile}" --username=qsmaster --host=ccqserv100 --port=4040 "$f" 
done

