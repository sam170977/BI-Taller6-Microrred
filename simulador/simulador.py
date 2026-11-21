"""Simulador de telemetria de la microrred (2 inversores) -> operativo.lectura_stream.

Cada fila es la energia (kWh) de un "intervalo sintetico acelerado" de 15 min fisicos (dt=0,25 h),
con las mismas unidades que silver.lectura_15min. Se escribe con ts = ahora, asi Grafana,
$__timeFilter y las alertas de "sin datos" funcionan en vivo.

SIM_MODO: lote (termina; CronJob) | continuo (docker compose)
SIM_ESCENARIO: normal | nublado | falla_bateria | perdida_telemetria | falla_inversor | sin_datos   (ConfigMap)
"""
import math, os, random, sys, time
from datetime import datetime
from zoneinfo import ZoneInfo
import psycopg

E = os.environ.get
DSN = (f"host={E('PGHOST','postgres')} port={E('PGPORT','5432')} dbname={E('POSTGRES_DB','microrred_bi')} "
       f"user={E('POSTGRES_USER','bi_user')} password={E('POSTGRES_PASSWORD','')}")
PUNTOS = int(E("SIM_PUNTOS", "3"))        # intervalos por inversor en cada ejecucion
PASO_S = float(E("SIM_PASO_SEG", "15"))   # segundos entre intervalos
ESCENARIO = E("SIM_ESCENARIO", "normal")
MODO = E("SIM_MODO", "lote")
HORA_FORZADA = E("SIM_HORA", "")          # p. ej. "12" = sol; "22" = noche
TZ = ZoneInfo("America/Bogota")
DT_H = 0.25                                # 15 min fisicos

INV = {1: dict(kwp=5.0, bat=10.0, base=1.2), 2: dict(kwp=5.0, bat=10.0, base=1.0)}
P_BAT_MAX, P_FALLA, SOC_MIN = 3.0, 2.0, 10.0
nube = {1: 0.9, 2: 0.9}


def hora():
    if HORA_FORZADA:
        return float(HORA_FORZADA)
    n = datetime.now(TZ)
    return n.hour + n.minute / 60


def paso(inv, soc):
    c, h = INV[inv], hora()
    sol = max(0.0, math.sin(math.pi * (h - 6) / 12)) if 6 <= h <= 18 else 0.0
    nube[inv] = min(1.0, max(0.5, nube[inv] + random.uniform(-0.05, 0.05)))
    pv = c["kwp"] * 0.85 * sol * nube[inv]
    carga = c["base"] + random.uniform(0, 0.8) + (random.uniform(2, 3) if random.random() < 0.1 else 0)
    if ESCENARIO == "nublado":
        pv *= 0.15
    neto = pv - carga
    if ESCENARIO == "falla_bateria":
        p_bat = min(P_FALLA, soc / 100 * c["bat"] / DT_H)           # descarga forzada
    elif neto > 0 and soc < 100:
        p_bat = -min(neto, P_BAT_MAX, (100 - soc) / 100 * c["bat"] / DT_H)
    elif neto < 0 and soc > SOC_MIN:
        p_bat = min(-neto, P_BAT_MAX, (soc - SOC_MIN) / 100 * c["bat"] / DT_H)
    else:
        p_bat = 0.0
    soc = min(100.0, max(0.0, soc - p_bat * DT_H / c["bat"] * 100))
    red = max(0.0, carga - pv - p_bat)                               # solo importacion, como Silver
    return pv * DT_H, carga * DT_H, red * DT_H, p_bat * DT_H, soc


def main():
    if ESCENARIO == "sin_datos":
        print("escenario sin_datos: no se inserta nada (prueba de la alerta de disponibilidad)")
        return
    with psycopg.connect(DSN, autocommit=True) as conn, conn.cursor() as cur:
        soc = {}
        for i in INV:
            cur.execute("SELECT soc_prom_pct FROM operativo.lectura_stream WHERE inversor_id=%s ORDER BY ts DESC LIMIT 1", (i,))
            r = cur.fetchone()
            soc[i] = float(r[0]) if r else 70.0
        while True:
            for k in range(PUNTOS):
                for i in INV:
                    pv, ca, rd, bt, soc[i] = paso(i, soc[i])
                    n_val = 1 if ESCENARIO == "perdida_telemetria" else 3   # 3 lecturas por intervalo, como Silver
                    cur.execute(
                        """INSERT INTO operativo.lectura_stream
                           (inversor_id, ts, e_pv_kwh, e_carga_kwh, e_red_kwh, e_bat_kwh, soc_prom_pct, n_lecturas, n_validas, escenario)
                           VALUES (%s, clock_timestamp(), %s, %s, %s, %s, %s, 3, %s, %s) ON CONFLICT DO NOTHING""",
                        (i, round(pv, 4), round(ca, 4), round(rd, 4), round(bt, 4), round(soc[i], 2), n_val, ESCENARIO))
                if ESCENARIO == "falla_inversor":
                    cur.execute("""INSERT INTO operativo.evento_inversor (inversor_id, severidad, codigo, descripcion)
                                   VALUES (1, 'grave', 'INV_FAULT', 'Falla simulada del inversor')""")
                if k < PUNTOS - 1 or MODO == "continuo":
                    time.sleep(PASO_S)
            print(f"[{ESCENARIO}] {PUNTOS} intervalos x {len(INV)} inversores", flush=True)
            if MODO == "lote":
                break


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print("ERROR:", e, file=sys.stderr)
        sys.exit(1)
