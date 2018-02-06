Qserv S15 Large Scale test benchmark
====================================

.. code-block:: bash

   # Run full benchmark against kubernetes cluster
   # kubernetes master runs on <node>
   ./run-all.sh -K -M <node>

   # Run only long queries
   KUBE=true CLIENT_NODE=ccqserv100 ./long-queries.sh

   # Run only one query (may not work, depending on your shell)
   KUBE=true CLIENT_NODE=ccqserv100
   . ./env.sh
   SQL="select min(ra), max(ra), min(decl), max(decl) from Object;"
   mysql_query "$SQL"

Monitor query execution
=======================

.. code-block:: bash

    # First, ssh to kubernetes node
    # then display running chunk-queries
    kubectl exec worker-1 -- bash -c ". /qserv/stack/loadLSST.bash && setup mariadbclient && mysql --socket /qserv/run/var/lib/mysql/mysql.sock --user=root --password=changeme -e 'SHOW PROCESSLIST'"
    Id      User    Host    db      Command Time    State   Info    Progress
    7       qsmaster        localhost       NULL    Sleep   302             NULL    0.000
    524     monitor localhost       NULL    Sleep   10              NULL    0.000
    713     qsmaster        localhost       NULL    Query   372     Sending data    SELECT count(*) AS QS1_COUNT FROM LSST.Object_1025 AS o,LSST.Source_1025 AS s WHERE o.deepSourceId=s    0.000
    714     qsmaster        localhost       NULL    Query   372     Sending data    SELECT count(*) AS QS1_COUNT FROM LSST.Object_1049 AS o,LSST.Source_1049 AS s WHERE o.deepSourceId=s    0.000
    717     qsmaster        localhost       NULL    Query   303     Sending data    SELECT count(*) AS QS1_COUNT FROM LSST.Object_1381 AS o,LSST.Source_1381 AS s WHERE o.deepSourceId=s    0.000
    718     qsmaster        localhost       NULL    Query   302     Sending data    SELECT count(*) AS QS1_COUNT FROM LSST.Object_1405 AS o,LSST.Source_1405 AS s WHERE o.deepSourceId=s    0.000
    721     root    localhost       NULL    Query   0       init    SHOW PROCESSLIST        0.000

    # Then explain a given chunk query
    kubectl exec worker-1 -- bash -c ". /qserv/stack/loadLSST.bash && setup mariadbclient && mysql --socket /qserv/run/var/lib/mysql/mysql.sock --user=root --password=changeme -e 'SHOW EXPLAIN FOR 717'"
    id      select_type     table   type    possible_keys   key     key_len ref     rows    Extra
    1       SIMPLE  o       index   PRIMARY PRIMARY 8       NULL    292531  Using index
    1       SIMPLE  s       ref     objectId        objectId        8       LSST.o.deepSourceId     22      Using where

    # WARN: execution plan for this query is not correct, it should do a fullscan of source and use o.deepSourceId index to retrieve object tuples
