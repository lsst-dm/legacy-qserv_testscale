if [ -z "$MASTER" ]; then
    echo "ERROR: undefined \$MASTER"
	exit 1
fi

function mysql_query {
    sql="$1"
    sleep_delay="$2"

    user="qsmaster"
    db="LSST"
    container="qserv"
	port=4040

	echo "Query: $sql"
    ssh "$MASTER" "docker exec '$container' bash -c '. /qserv/stack/loadLSST.bash && \
        setup mariadb && \
		start=\$(date +%s.%N) && \
        mysql -N -B --host \"$MASTER\" --port $port \
        --user=$user $db -e \"$sql\" && \
		end=\$(date +%s.%N) &&
		echo \"Execution time: \$(python -c \"print(\${end} - \${start})\")\"'"

	runtime=$((end-start))

    echo
    if [ -n "$sleep_delay" ]; then
        sleep "$sleep_delay"
    fi
}

