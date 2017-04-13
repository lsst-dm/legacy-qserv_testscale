set -x
CHUNKS=$(ls /mnt/qserv/data/mysql/LSST/Object_*.frm | cut -d'_' -f2 | cut -d '.' -f 1)
CONTAINER=$(docker ps -l -q)
echo "container id: $CONTAINER"

for chunk in $CHUNKS;
do
  docker exec -- "$CONTAINER" bash -c ". /qserv/stack/loadLSST.bash && setup mariadbclient && mysql --socket /qserv/run/var/lib/mysql/mysql.sock --user=qsmaster -e \"SELECT COUNT(*) AS QS1_COUNT FROM LSST.Object_$chunk AS QST_1_ WHERE y_instFlux>5\""
done
