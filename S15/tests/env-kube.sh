CLIENT_NODE=${CLIENT_NODE:?}

if [ -z "$CLIENT_NODE" ]; then
    echo "ERROR: undefined \$CLIENT_NODE"
    exit 1
fi

# Parallel invokes the shell indicated by the SHELL environment variable
export SHELL=$(type -p bash)

function mysql_query {
    sql="$1"
    sleep_delay="$2"

    SSH_CFG="$HOME/.lsst/qserv-cluster/ssh_config"
    # ssh option for using configuration file
    if [ -r "$SSH_CFG" ]; then
        SSH_CFG_OPT="-F $SSH_CFG"
    else
        SSH_CFG_OPT=
    fi

    user="qsmaster"
    db="LSST"
    port=4040

    query_cmd="start=\$(date +%s.%N) && \
        mysql -N -B --host \"127.0.0.1\" --port $port --user=$user $db -e \"$sql\" && \
        end=\$(date +%s.%N) && \
        echo \"Execution time: \$(python -c \"print(\${end} - \${start})\") sec\""
    
    if [ -n "$KUBE" ]; then
        orch_cmd="kubectl exec master"
    else
        orch_cmd="docker exec qserv"
    fi

    echo "Query: $sql"
    echo "Date: $(date +%Y-%m-%d_%H:%M:%S)"
    ssh $SSH_CFG_OPT "$CLIENT_NODE" "$orch_cmd -- bash -c '. /qserv/stack/loadLSST.bash && \
        setup mariadb && \
        $query_cmd'"
    echo "Date: $(date +%Y-%m-%d_%H:%M:%S)"

    echo
    if [ -n "$sleep_delay" ]; then
        sleep "$sleep_delay"
    fi
}

