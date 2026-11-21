#!/bin/bash
# Rol de solo lectura para Grafana y Power BI. Corre al final (despues de crear gold, bi y operativo).
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<SQL
DO \$\$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'bi_lectura') THEN
    CREATE ROLE bi_lectura LOGIN PASSWORD '${BI_LECTURA_PASSWORD}';
  END IF;
END \$\$;
GRANT CONNECT ON DATABASE "${POSTGRES_DB}" TO bi_lectura;
GRANT USAGE ON SCHEMA gold, bi, operativo TO bi_lectura;
GRANT SELECT ON ALL TABLES IN SCHEMA gold, bi, operativo TO bi_lectura;
ALTER DEFAULT PRIVILEGES IN SCHEMA gold, bi, operativo GRANT SELECT ON TABLES TO bi_lectura;
SQL
