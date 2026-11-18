import os
import sys
import json
import sqlite3
from datetime import datetime, timezone, timedelta
import psycopg

SQLITE_PATH = os.getenv("SQLITE_PATH", r"C:\datos\opencem.sqlite")
PG_DSN = os.getenv(
    "PG_DSN",
    "postgresql://postgres:postgres@localhost:5432/opencem"
)

# Zona horaria local del sitio documentada en el contrato SQL (UTC+8)
SITE_TZ = timezone(timedelta(hours=8))

# Claves sensibles a descartar en contexto (Ley 1581 de 2012 - Minimización)
CLAVES_SENSIBLES = {
    "directory", "command", "task_files",
    "windows_event", "latitude", "longitude"
}

def cargar_lectura_15min(sq_cur, pg_cur):
    print("\n--- 1. PROCESANDO analog_measurements -> silver.lectura_15min ---")
    sq_cur.execute("SELECT COUNT(*) FROM analog_measurements;")
    total_bruto = sq_cur.fetchone()[0]
    print(f"[Bronze] Filas totales en analog_measurements: {total_bruto:,}")

    # Regla 1: Descartar timestamps o inversores nulos/inválidos (inversor debe ser 1 o 2)
    sq_cur.execute("""
        SELECT COUNT(*) FROM analog_measurements
        WHERE read_ts IS NULL OR inverter NOT IN (1, 2);
    """)
    desc_meta = sq_cur.fetchone()[0]
    print(f"[Regla 1 - Metadatos] Descartadas por read_ts nulo o inversor != 1,2: {desc_meta:,}")

    # Regla 2: Conteo de lecturas fuera de rango físico o con sensores de potencia nulos
    # Rangos físicos: pv1power [0..15000 W], outsumw [0..15000 W], gridpowerw_a [-15000..15000 W], battsoc [0..100 %]
    sq_cur.execute("""
        SELECT COUNT(*) FROM analog_measurements
        WHERE read_ts IS NOT NULL AND inverter IN (1, 2)
          AND (
              pv1power IS NULL OR pv1power < 0 OR pv1power > 15000
              OR outsumw IS NULL OR outsumw < 0 OR outsumw > 15000
              OR gridpowerw_a IS NULL OR gridpowerw_a < -15000 OR gridpowerw_a > 15000
          );
    """)
    no_validas = sq_cur.fetchone()[0]
    print(f"[Regla 2 - Rango/Nulos potencia] Lecturas marcadas como no válidas (se conservan en n_lecturas, excluidas de n_validas): {no_validas:,}")

    # Agregación a bloques de 15 minutos (900 segundos) directo en SQLite por eficiencia
    print("Agregando a intervalos de 15 minutos (esto toma ~15-30 segundos)...")
    sq_cur.execute("""
        SELECT
            inverter AS inversor_id,
            CAST(read_ts / 900 AS INTEGER) * 900 AS bucket_epoch,
            AVG(CASE WHEN pv1power BETWEEN 0 AND 15000
                      AND outsumw BETWEEN 0 AND 15000
                      AND gridpowerw_a BETWEEN -15000 AND 15000
                 THEN pv1power END) AS avg_pv_w,
            AVG(CASE WHEN pv1power BETWEEN 0 AND 15000
                      AND outsumw BETWEEN 0 AND 15000
                      AND gridpowerw_a BETWEEN -15000 AND 15000
                 THEN outsumw END) AS avg_carga_w,
            AVG(CASE WHEN pv1power BETWEEN 0 AND 15000
                      AND outsumw BETWEEN 0 AND 15000
                      AND gridpowerw_a BETWEEN -15000 AND 15000
                 THEN MAX(gridpowerw_a, 0) END) AS avg_red_w,
            AVG(CASE WHEN battsoc BETWEEN 0 AND 100 THEN battsoc END) AS soc_prom,
            COUNT(*) AS n_lecturas,
            SUM(CASE WHEN pv1power BETWEEN 0 AND 15000
                      AND outsumw BETWEEN 0 AND 15000
                      AND gridpowerw_a BETWEEN -15000 AND 15000
                 THEN 1 ELSE 0 END) AS n_validas
        FROM analog_measurements
        WHERE read_ts IS NOT NULL AND inverter IN (1, 2)
        GROUP BY inverter, bucket_epoch;
    """)

    rows = sq_cur.fetchall()
    print(f"[Silver] Intervalos de 15 min generados: {len(rows):,}")

    batch = []
    for inv, epoch, pv_w, carga_w, red_w, soc, n_lec, n_val in rows:
        ts_inicio = datetime.fromtimestamp(epoch, tz=timezone.utc)
        # Energía (kWh) = Potencia promedio (W) / 1000 * 0.25 h
        e_pv = round((pv_w / 1000.0) * 0.25, 4) if pv_w is not None else None
        e_carga = round((carga_w / 1000.0) * 0.25, 4) if carga_w is not None else None
        e_red = round((red_w / 1000.0) * 0.25, 4) if red_w is not None else None
        soc_pct = round(soc, 2) if soc is not None else None
        batch.append((inv, ts_inicio, e_pv, e_carga, e_red, soc_pct, n_lec, n_val))

    sql_upsert = """
        INSERT INTO silver.lectura_15min
            (inversor_id, ts_inicio, e_pv_kwh, e_carga_kwh, e_red_kwh, soc_prom_pct, n_lecturas, n_validas)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT (inversor_id, ts_inicio) DO UPDATE SET
            e_pv_kwh = EXCLUDED.e_pv_kwh,
            e_carga_kwh = EXCLUDED.e_carga_kwh,
            e_red_kwh = EXCLUDED.e_red_kwh,
            soc_prom_pct = EXCLUDED.soc_prom_pct,
            n_lecturas = EXCLUDED.n_lecturas,
            n_validas = EXCLUDED.n_validas;
    """
    pg_cur.executemany(sql_upsert, batch)
    print(f"[PostgreSQL] Cargados/actualizados en silver.lectura_15min: {len(batch):,} registros.")


def cargar_contador_diario(sq_cur, pg_cur):
    print("\n--- 2. PROCESANDO statistics -> silver.contador_diario ---")
    sq_cur.execute("SELECT COUNT(*) FROM statistics;")
    total_bruto = sq_cur.fetchone()[0]
    print(f"[Bronze] Filas totales en statistics: {total_bruto:,}")

    sq_cur.execute("""
        SELECT
            inverter,
            date(read_ts + 28800, 'unixepoch') AS fecha_local,
            MAX(COALESCE(pvgeneratenergytoday, 0)),
            MAX(COALESCE(usedenergytoday, 0)),
            MAX(COALESCE(loadconsumlinetday, 0)),
            MAX(COALESCE(batchgenergytoday, 0)),
            MAX(COALESCE(batdischgenergytoday, 0)),
            MAX(COALESCE(linechgenergytday, 0)),
            COUNT(*)
        FROM statistics
        WHERE read_ts IS NOT NULL AND inverter IN (1, 2)
          AND (pvgeneratenergytoday IS NOT NULL OR usedenergytoday IS NOT NULL)
        GROUP BY inverter, fecha_local;
    """)

    rows = sq_cur.fetchall()
    print(f"[Silver] Días-inversor consolidados: {len(rows):,}")

    sql_upsert = """
        INSERT INTO silver.contador_diario
            (inversor_id, fecha_local, pv_kwh, carga_kwh, carga_red_kwh,
             bateria_carga_kwh, bateria_desc_kwh, bateria_carga_red_kwh, n_lecturas)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT (inversor_id, fecha_local) DO UPDATE SET
            pv_kwh = EXCLUDED.pv_kwh,
            carga_kwh = EXCLUDED.carga_kwh,
            carga_red_kwh = EXCLUDED.carga_red_kwh,
            bateria_carga_kwh = EXCLUDED.bateria_carga_kwh,
            bateria_desc_kwh = EXCLUDED.bateria_desc_kwh,
            bateria_carga_red_kwh = EXCLUDED.bateria_carga_red_kwh,
            n_lecturas = EXCLUDED.n_lecturas;
    """
    pg_cur.executemany(sql_upsert, rows)
    print(f"[PostgreSQL] Cargados/actualizados en silver.contador_diario: {len(rows):,} registros.")


def cargar_contexto(sq_cur, pg_cur):
    print("\n--- 3. PROCESANDO context -> silver.contexto ---")
    sq_cur.execute("SELECT id, recorded, start, end, value FROM context WHERE value IS NOT NULL;")
    rows = sq_cur.fetchall()
    print(f"[Bronze] Filas en context: {len(rows):,}")

    batch = []
    descartados_json = 0
    for id_orig, rec, ini, fin, val_str in rows:
        try:
            obj = json.loads(val_str)
            if not isinstance(obj, dict):
                descartados_json += 1
                continue
            # Minimización de datos personales (Ley 1581 de 2012)
            obj_limpio = {k: v for k, v in obj.items() if k not in CLAVES_SENSIBLES}
            reg_ts = datetime.fromtimestamp(rec, tz=timezone.utc) if rec else None
            ini_ts = datetime.fromtimestamp(ini, tz=timezone.utc)
            fin_ts = datetime.fromtimestamp(fin if fin >= ini else ini, tz=timezone.utc)
            batch.append((id_orig, reg_ts, ini_ts, fin_ts, json.dumps(obj_limpio)))
        except Exception:
            descartados_json += 1

    print(f"[Regla 3 - JSON] Descartados por JSON malformado: {descartados_json:,}")

    sql_upsert = """
        INSERT INTO silver.contexto (id_origen, registrado_ts, inicio_ts, fin_ts, valor)
        VALUES (%s, %s, %s, %s, %s::jsonb)
        ON CONFLICT (id_origen) DO UPDATE SET
            registrado_ts = EXCLUDED.registrado_ts,
            inicio_ts = EXCLUDED.inicio_ts,
            fin_ts = EXCLUDED.fin_ts,
            valor = EXCLUDED.valor;
    """
    pg_cur.executemany(sql_upsert, batch)
    print(f"[PostgreSQL] Cargados/actualizados en silver.contexto: {len(batch):,} registros.")


def main():
    print(f"Conectando a SQLite: {SQLITE_PATH}")
    sq_conn = sqlite3.connect(SQLITE_PATH)
    sq_cur = sq_conn.cursor()

    print(f"Conectando a PostgreSQL...")
    with psycopg.connect(PG_DSN) as pg_conn:
        with pg_conn.cursor() as pg_cur:
            cargar_lectura_15min(sq_cur, pg_cur)
            cargar_contador_diario(sq_cur, pg_cur)
            cargar_contexto(sq_cur, pg_cur)
        pg_conn.commit()

    sq_conn.close()
    print("\n=== ETL BRONZE -> SILVER COMPLETADO CON EXITO ===")

if __name__ == "__main__":
    main()
