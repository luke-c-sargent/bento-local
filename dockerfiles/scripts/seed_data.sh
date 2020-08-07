#!/bin/bash

# sleep until the neo4j process is started and listening on port 7687
echo >&2 "Waiting for Neo4j to be available before loading data..."
timeout 120 bash -c 'until printf "" 2>>/dev/null >>/dev/tcp/$0/$1; do sleep 1; done' localhost 7687

# load and remove all files copied to the import directory
echo >&2 "Seeding Bento data..."

# verify that the database is empty before loading seed data
isEmpty=$(echo "MATCH (n) RETURN count(n);" | NEO4J_USERNAME=neo4j NEO4J_PASSWORD=$NEO4J_PASS bin/cypher-shell --fail-fast)
isEmpty=${isEmpty#"count(n)"}
if [ $isEmpty -eq 0 ]; then

for f in import/*
do [ -f "$f" ] || continue
  echo >&2 "Loading Bento data:  $f" && cat "$f" | NEO4J_USERNAME=neo4j NEO4J_PASSWORD=$NEO4J_PASS bin/cypher-shell --fail-fast && rm "$f"
done 

fi