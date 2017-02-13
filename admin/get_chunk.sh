#!/bin/sh

# print chunk on all nodes 

# @author Fabrice Jammes IN2P3

DATA_DIR=/mnt/qserv/data/mysql/LSST

DIRECTOR_TABLE=Object

echo "List chunks in $DATA_DIR on all nodes"
parallel --nonall --slf .. "find  $DATA_DIR -name \"${DIRECTOR_TABLE}_*.frm\"" | \
    grep -v "1234567890.frm" | \
	cut -d'.' -f1 | sed s/^.*${DIRECTOR_TABLE}_// | \
	sort > chunk.txt
