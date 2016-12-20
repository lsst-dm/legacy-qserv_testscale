#!/bin/bash

# Test script which launches SQL queries against
# S15 Large Scale Tests Dataset
# see: https://confluence.lsstcorp.org/display/DM/S15+Large+Scale+Tests

# @author  Fabrice Jammes, IN2P3

set -e
set -x

DIR=$(cd "$(dirname "$0")"; pwd -P)

MASTER=$(hostname)

usage() {
  cat << EOD

  Usage: $(basename $0) [options]

  Available options:
    -h          this message
    -M          Hostname for Qserv master, default to \$hostname 
    -O          Output directory, default to $DIR/out/<master> 

  Launch a set of SQL queries against S15 Large Scale Tests dataset.

EOD
}

# get the options
while getopts hM:O: c ; do
    case $c in
        h) usage ; exit 0 ;;
        M) MASTER="$OPTARG" ;;
        O) OUT_DIR="$OPTARG" ;;
        \?) usage ; exit 2 ;;
    esac
done
shift $(($OPTIND - 1))

if [ $# -ne 0 ] ; then
    usage
    exit 2
fi

OUT_DIR="$DIR/out/$MASTER/"
mkdir -p "$OUT_DIR"

export MASTER
. "${DIR}/env.sh"

"$DIR"/short-queries.sh >& "$OUT_DIR/short.out"
"$DIR"/count-queries.sh >& "$OUT_DIR/count.out"
"$DIR"/long-queries.sh >& "$OUT_DIR/long.out"
"$DIR"/sscan-queries.sh >& "$OUT_DIR/sscan.out"
