#!/bin/bash

# seed the bento 50k data set
mkdir -p /data/databases/graph.db && bin/neo4j-admin load --from=bento-data.dump --database=graph.db --force

# Start the primary process
/docker-entrypoint.sh neo4j 