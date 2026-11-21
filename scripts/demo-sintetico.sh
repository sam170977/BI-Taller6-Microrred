#!/usr/bin/env bash
# SOLO si aun no hay datos reales: carga sql/07 (junio 2026 sintetico) y la capa Gold.
set -euo pipefail
cd "$(dirname "$0")/.."; set -a; . ./k8s/.env; set +a
psql_() { kubectl -n microrred-bi exec -i postgres-0 -- psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"; }
psql_ < sql/07_datos_demo_sinteticos.sql
psql_ < sql/03_carga_gold.sql
