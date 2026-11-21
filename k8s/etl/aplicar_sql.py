"""Ejecuta un archivo .sql contra PostgreSQL (PG_DSN). Se usa para la carga Silver -> Gold (sql/03_carga_gold.sql, idempotente)."""
import os, sys
import psycopg

ruta = sys.argv[1]
with open(ruta, encoding="utf-8-sig") as f:
    sql = f.read()
with psycopg.connect(os.environ["PG_DSN"]) as conn:
    conn.execute(sql)
    conn.commit()
print(f"OK: {ruta} aplicado")
