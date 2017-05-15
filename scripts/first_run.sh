#!/bin/bash
USER=${MONGODB_USERNAME:-mongo}
PASS=${MONGODB_PASSWORD:-$(pwgen -s -1 16)}
DB=${MONGODB_DBNAME:-admin}

if [ ! -z "$MONGODB_DBNAME" ]
then
    ROLE=${MONGODB_ROLE:-dbOwner}
else
    ROLE=${MONGODB_ROLE:-dbAdminAnyDatabase}
fi

# Check for NUMA machine and start MongoDB service
# if [[`numactl --hardware | head -1 | cut -b 12` != '1']]; then
numactl --interleave=all /usr/bin/mongod --dbpath /data --rest --httpinterface --journal $@

# else
  # mongod --dbpath /data --rest --httpinterface --journal $@;
# fi

# numactl --interleave=all mongod --dbpath /data --rest --httpinterface --journal $@
while ! nc -vz localhost 27017; do sleep 1; done

# Create User
echo "Creating user: \"$USER\"..."
mongo $DB --eval "db.createUser({ user: '$USER', pwd: '$PASS', roles: [ { role: '$ROLE', db: '$DB' } ] });"

# Stop MongoDB service
/usr/bin/mongod --dbpath /data --shutdown

echo "========================================================================"
echo "MongoDB User: \"$USER\""
echo "MongoDB Password: \"$PASS\""
echo "MongoDB Database: \"$DB\""
echo "MongoDB Role: \"$ROLE\""
echo "========================================================================"

rm -f /.firstrun
