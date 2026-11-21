-- Esquema OPERATIVO: telemetria sintetica "en vivo" que escribe el simulador y lee Grafana.
-- Va separado de gold.* a proposito: los datos simulados NO contaminan el modelo analitico (Power BI).
-- Unidades iguales a silver.lectura_15min: energia (kWh) por intervalo. Cada fila es un
-- "intervalo sintetico acelerado": 1 minuto de reloj real representa 15 min fisicos.
CREATE SCHEMA IF NOT EXISTS operativo;

CREATE TABLE IF NOT EXISTS operativo.lectura_stream (
  inversor_id   INT          NOT NULL CHECK (inversor_id IN (1, 2)),
  ts            TIMESTAMPTZ  NOT NULL,
  e_pv_kwh      NUMERIC(12,4) NOT NULL CHECK (e_pv_kwh >= 0),
  e_carga_kwh   NUMERIC(12,4) NOT NULL CHECK (e_carga_kwh >= 0),
  e_red_kwh     NUMERIC(12,4) NOT NULL CHECK (e_red_kwh >= 0),     -- energia tomada de la red
  e_bat_kwh     NUMERIC(12,4) NOT NULL,                            -- + descarga / - carga
  soc_prom_pct  NUMERIC(5,2)  NOT NULL CHECK (soc_prom_pct BETWEEN 0 AND 100),
  n_lecturas    SMALLINT      NOT NULL DEFAULT 3 CHECK (n_lecturas >= 0),   -- como silver.lectura_15min
  n_validas     SMALLINT      NOT NULL DEFAULT 3 CHECK (n_validas BETWEEN 0 AND 3),
  escenario     TEXT          NOT NULL,
  PRIMARY KEY (inversor_id, ts)                                    -- idempotencia
);
CREATE INDEX IF NOT EXISTS ix_stream_ts ON operativo.lectura_stream (ts DESC);

-- Eventos de falla del inversor (alerta "Fallo de inversor"). Los escribe el simulador.
CREATE TABLE IF NOT EXISTS operativo.evento_inversor (
  evento_id    BIGSERIAL PRIMARY KEY,
  ts           TIMESTAMPTZ NOT NULL DEFAULT now(),
  inversor_id  INT  NOT NULL CHECK (inversor_id IN (1, 2)),
  severidad    TEXT NOT NULL CHECK (severidad IN ('info', 'advertencia', 'grave')),
  codigo       TEXT NOT NULL,
  descripcion  TEXT
);
CREATE INDEX IF NOT EXISTS ix_evento_ts ON operativo.evento_inversor (ts DESC);
