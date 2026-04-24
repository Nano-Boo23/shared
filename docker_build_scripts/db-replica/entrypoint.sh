#!/bin/bash
set -e

echo "Esperando a db-primaria..."
sleep 10

rm -rf /var/lib/postgresql/data/*

export PGPASSWORD=replicator

pg_basebackup -h db-primaria -D /var/lib/postgresql/data -U replicator -Fp -Xs -P -R

echo "Arrancando replica..."
exec postgres
