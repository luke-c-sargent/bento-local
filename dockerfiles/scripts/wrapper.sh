#!/bin/bash

# turn on bash's job control
set -m

# Start the primary process and put it in the background
/docker-entrypoint.sh neo4j &

# Start the data loader script
./seed_data.sh

# bring the primary process back into the foreground
# and leave it there
fg %1