#!/bin/bash

# Test script which launches SQL queries against
# S15 Large Scale Tests Dataset
# see: https://confluence.lsstcorp.org/display/DM/S15+Large+Scale+Tests

# @author  Fabrice Jammes, IN2P3

set -e
set -x

DIR=$(cd "$(dirname "$0")"; pwd -P)
CLIENT_NODE=$(hostname)
OUT_DIR="$DIR/out/$(hostname)"

usage() {
  cat << EOD

  Usage: $(basename $0) [options]

  Available options:
    -h          this message
    -K          Launch against a Kubernetes-managed cluster
                instead of a shmux-managed one
    -M          Hostname for node enabling access to Qserv client 
                i.e. node running Qserv master container in shmux mode
                and kubernetes master in kubernetes mode,
                default to \$hostname 
    -O          Output directory, default to $DIR/out/<hostname>

  Launch a set of SQL queries against S15 Large Scale Tests dataset.

EOD
}

# get the options
while getopts hKM:O: c ; do
    case $c in
        h) usage ; exit 0 ;;
        K) KUBE=true ;;
        M) CLIENT_NODE="$OPTARG" ;;
        O) OUT_DIR="$OPTARG" ;;
        \?) usage ; exit 2 ;;
    esac
done
shift $(($OPTIND - 1))

if [ $# -ne 0 ] ; then
    usage
    exit 2
fi

mkdir -p "$OUT_DIR"

export KUBE 
export CLIENT_NODE 

"$DIR"/short-queries.sh >& "$OUT_DIR/short.out"
"$DIR"/count-queries.sh >& "$OUT_DIR/count.out"
"$DIR"/long-queries.sh >& "$OUT_DIR/long.out"
"$DIR"/sscan-queries.sh >& "$OUT_DIR/sscan.out"
