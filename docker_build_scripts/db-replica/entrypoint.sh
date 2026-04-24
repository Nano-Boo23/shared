#!/bin/bash
set -e

echo "Esperando a db-primaria..."
until pg_isready -h db-primaria -p 5432 -U replicator; do
  sleep 2
done

echo "Limpiando datos previos..."
rm -rf /var/lib/postgresql/data/*

echo "Cambiando permisos de postgresql/data..."
chmod 700 /var/lib/postgresql/data

export PGPASSWORD=replicator

echo "Copiando base desde la primaria..."
pg_basebackup -h db-primaria -D /var/lib/postgresql/data -U replicator -Fp -Xs -P -R

echo "Asegurando permisos finales..."
chmod 700 /var/lib/postgresql/data

echo "Arrancando replica..."
exec postgres
