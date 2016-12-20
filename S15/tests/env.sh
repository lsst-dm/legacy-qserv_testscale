if [ -z "$MASTER" ]; then
    echo "ERROR: undefined \$MASTER"
	exit 1
fi

function mysql_query {
    master="$1"
    sql="$2"
    sleep_delay="$3"

    user="qsmaster"
    db="LSST"
    container="qserv"
	port=4040

    ssh "$master" "docker exec '$container' bash -c '. /qserv/stack/loadLSST.bash && \
        setup mariadb && \
		start=\$(date +%s.%N) && \
        mysql -N -B --host \"$master\" --port $port \
        --user=$user $db -e \"$sql\" && \
		end=\$(date +%s.%N) &&
		echo \"Execution time: \$(python -c \"print(\${end} - \${start})\")\"'"

	runtime=$((end-start))

    echo
    if [ -n "$sleep_delay" ]; then
        sleep "$sleep_delay"
    fi
}
