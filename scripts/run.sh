#!/bin/bash

# Initialize first run
if [[ -e /.firstrun ]]; then
    /scripts/first_run.sh
fi

# Start MongoDB
echo "Starting MongoDB..."

# mongod --rest --httpinterface --dbpath /data $@

numactl --interleave=all mongod --rest --httpinterface --dbpath /data $@
