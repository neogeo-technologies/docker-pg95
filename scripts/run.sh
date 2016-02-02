#!/bin/bash

# If the superuser password is not defnied in an environment variable
# it is randomly generated
PASS=${SUPERPASS:-$(pwgen -s -1 16)}

# Initialize data directory
if [ ! -f $PGDATA/postgresql.conf ]; then
	echo "SUPERUSER: \"$SUPERUSER\""
	echo "SUPERPASS: \"$PASS\""
	echo "PGDATA: \"$PGDATA\""
	echo "...Data dir creation..."
    mkdir -p $PGDATA
    chown postgres:postgres $PGDATA

	echo "...Database config..."
#	gosu postgres /usr/pgsql-9.5/bin/initdb -E utf8 --locale en_US.UTF-8 -D ${PGDATA}
	gosu postgres /usr/pgsql-9.5/bin/initdb -E utf8 --locale fr_FR.UTF-8 -D ${PGDATA}
	echo "host    all             all             0.0.0.0/0               md5" >> ${PGDATA}/pg_hba.conf
	echo "local all postgres trust" >> $PGDATA/pg_hba.conf
	echo "listen_addresses='*'" >> ${PGDATA}/postgresql.conf
fi

gosu postgres chown -R postgres:postgres $PGDATA
gosu postgres chmod -R 700 $PGDATA

# Initialize first run
if [[ -e /.firstrun ]]; then
	echo "...Database initialization, superuser creation..."

	# fire up db, create superuser, shut down
	gosu postgres /usr/pgsql-9.5/bin/pg_ctl -w start
	echo create role $SUPERUSER SUPERUSER LOGIN PASSWORD \'$PASS\' | gosu postgres psql
	gosu postgres /usr/pgsql-9.5/bin/pg_ctl -w stop
	rm -f /.firstrun
fi

# Start PostgreSQL
echo "...Starting PostgreSQL..."
gosu postgres /usr/pgsql-9.5/bin/postgres -i -c logging_collector=off