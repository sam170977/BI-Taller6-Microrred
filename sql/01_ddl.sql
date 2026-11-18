
CREATE SCHEMA IF NOT EXISTS gold;
CREATE EXTENSION IF NOT EXISTS btree_gist;   


CREATE TABLE IF NOT EXISTS gold.dim_fecha (
  fecha_key        INT PRIMARY KEY,               
  fecha            DATE NOT NULL UNIQUE,
  anio             SMALLINT NOT NULL,
  trimestre        SMALLINT NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
  mes              SMALLINT NOT NULL CHECK (mes BETWEEN 1 AND 12),
  nombre_mes       TEXT NOT NULL,
  semana_iso       SMALLINT NOT NULL,
  dia_semana       SMALLINT NOT NULL CHECK (dia_semana BETWEEN 1 AND 7),
  es_fin_de_semana BOOLEAN NOT NULL,
  es_festivo       BOOLEAN NOT NULL DEFAULT FALSE  
);

CREATE TABLE IF NOT EXISTS gold.dim_hora (
  hora_key    SMALLINT PRIMARY KEY CHECK (hora_key BETWEEN 0 AND 95),  
  hora_inicio TIME NOT NULL,
  hora        SMALLINT NOT NULL CHECK (hora BETWEEN 0 AND 23),
  franja      TEXT NOT NULL CHECK (franja IN ('madrugada','solar','tarde','noche'))
);

CREATE TABLE IF NOT EXISTS gold.dim_inversor (
  inversor_key    SERIAL PRIMARY KEY,
  inversor_id     INT NOT NULL,                   
  nombre          TEXT NOT NULL,
  cap_pv_kwp      NUMERIC(8,2) CHECK (cap_pv_kwp > 0),         
  cap_bateria_kwh NUMERIC(8,2) CHECK (cap_bateria_kwh >= 0),   
  vigente_desde   DATE NOT NULL,
  vigente_hasta   DATE NOT NULL DEFAULT '9999-12-31',
  es_actual       BOOLEAN NOT NULL DEFAULT TRUE,
  UNIQUE (inversor_id, vigente_desde),
  CHECK (vigente_hasta >= vigente_desde)
);

CREATE TABLE IF NOT EXISTS gold.dim_tarifa (
  tarifa_key    SERIAL PRIMARY KEY,
  operador      TEXT NOT NULL,
  nivel_tension SMALLINT NOT NULL CHECK (nivel_tension BETWEEN 1 AND 4),
  tipo_usuario  TEXT NOT NULL,
  cu_cop_kwh    NUMERIC(10,2) NOT NULL CHECK (cu_cop_kwh > 0),
  vigente_desde DATE NOT NULL,
  vigente_hasta DATE NOT NULL DEFAULT '9999-12-31',
  fuente        TEXT,
  CHECK (vigente_hasta >= vigente_desde),
  EXCLUDE USING gist (operador WITH =, nivel_tension WITH =, tipo_usuario WITH =,
                      daterange(vigente_desde, vigente_hasta, '[]') WITH &&)
);

CREATE TABLE IF NOT EXISTS gold.dim_tipo_evento (
  tipo_evento_key SERIAL PRIMARY KEY,
  categoria       TEXT NOT NULL,
  tipo            TEXT NOT NULL,
  UNIQUE (categoria, tipo),
  UNIQUE (tipo)
);


CREATE TABLE IF NOT EXISTS gold.fact_energia_intervalo (
  inversor_key  INT      NOT NULL REFERENCES gold.dim_inversor,
  ts_inicio     TIMESTAMPTZ NOT NULL,
  fecha_key     INT      NOT NULL REFERENCES gold.dim_fecha,
  hora_key      SMALLINT NOT NULL REFERENCES gold.dim_hora,
  tarifa_key    INT      NOT NULL REFERENCES gold.dim_tarifa,
  e_pv_kwh      NUMERIC(12,4) CHECK (e_pv_kwh >= 0),
  e_carga_kwh   NUMERIC(12,4) CHECK (e_carga_kwh >= 0),
  e_red_kwh     NUMERIC(12,4) CHECK (e_red_kwh >= 0),
  soc_prom_pct  NUMERIC(5,2)  CHECK (soc_prom_pct BETWEEN 0 AND 100),
  n_lecturas    SMALLINT NOT NULL CHECK (n_lecturas >= 0),
  n_validas     SMALLINT NOT NULL CHECK (n_validas BETWEEN 0 AND n_lecturas),
  PRIMARY KEY (inversor_key, ts_inicio)          
);
CREATE INDEX IF NOT EXISTS ix_fei_fecha_inv ON gold.fact_energia_intervalo (fecha_key, inversor_key);
CREATE INDEX IF NOT EXISTS ix_fei_hora      ON gold.fact_energia_intervalo (hora_key);
CREATE INDEX IF NOT EXISTS ix_fei_tarifa    ON gold.fact_energia_intervalo (tarifa_key);
CREATE INDEX IF NOT EXISTS brin_fei_ts      ON gold.fact_energia_intervalo USING brin (ts_inicio);


CREATE TABLE IF NOT EXISTS gold.fact_ahorro_diario (
  inversor_key INT NOT NULL REFERENCES gold.dim_inversor,
  fecha_key    INT NOT NULL REFERENCES gold.dim_fecha,
  tarifa_key   INT NOT NULL REFERENCES gold.dim_tarifa,
  e_pv_kwh            NUMERIC(12,3) NOT NULL CHECK (e_pv_kwh >= 0),
  e_carga_kwh         NUMERIC(12,3) NOT NULL CHECK (e_carga_kwh >= 0),
  e_red_carga_kwh     NUMERIC(12,3) NOT NULL CHECK (e_red_carga_kwh >= 0),    
  e_red_bateria_kwh   NUMERIC(12,3) NOT NULL CHECK (e_red_bateria_kwh >= 0),  
  e_bat_carga_kwh     NUMERIC(12,3) NOT NULL CHECK (e_bat_carga_kwh >= 0),
  e_bat_desc_kwh      NUMERIC(12,3) NOT NULL CHECK (e_bat_desc_kwh >= 0),
  e_red_imp_kwh       NUMERIC(12,3) GENERATED ALWAYS AS (e_red_carga_kwh + e_red_bateria_kwh) STORED,
  e_autoconsumo_kwh   NUMERIC(12,3) NOT NULL CHECK (e_autoconsumo_kwh >= 0),
  costo_evitado_cop       NUMERIC(14,2) NOT NULL,   
  costo_contrafactual_cop NUMERIC(14,2) NOT NULL,   
  costo_importacion_cop   NUMERIC(14,2) NOT NULL,   
  ahorro_neto_cop         NUMERIC(14,2) GENERATED ALWAYS AS (costo_contrafactual_cop - costo_importacion_cop) STORED,
  PRIMARY KEY (inversor_key, fecha_key, tarifa_key)
);
CREATE INDEX IF NOT EXISTS ix_fad_fecha ON gold.fact_ahorro_diario (fecha_key);


CREATE TABLE IF NOT EXISTS gold.fact_evento_contexto (
  evento_key       BIGSERIAL PRIMARY KEY,
  id_origen        INT NOT NULL UNIQUE,          
  tipo_evento_key  INT NOT NULL REFERENCES gold.dim_tipo_evento,
  fecha_inicio_key INT NOT NULL REFERENCES gold.dim_fecha,
  fecha_fin_key    INT NOT NULL REFERENCES gold.dim_fecha,
  ts_inicio        TIMESTAMPTZ NOT NULL,
  ts_fin           TIMESTAMPTZ NOT NULL,
  registrado_ts    TIMESTAMPTZ,
  duracion_h       NUMERIC(10,2) GENERATED ALWAYS AS (EXTRACT(EPOCH FROM (ts_fin - ts_inicio)) / 3600) STORED,
  contexto         JSONB NOT NULL,
  CHECK (ts_fin >= ts_inicio),
  CHECK (fecha_fin_key >= fecha_inicio_key)
);
CREATE INDEX IF NOT EXISTS ix_fec_fechas ON gold.fact_evento_contexto (fecha_inicio_key, fecha_fin_key);
CREATE INDEX IF NOT EXISTS gin_fec_ctx   ON gold.fact_evento_contexto USING gin (contexto);


INSERT INTO gold.dim_fecha
SELECT to_char(d,'YYYYMMDD')::int, d::date, EXTRACT(year FROM d), EXTRACT(quarter FROM d),
       EXTRACT(month FROM d), to_char(d,'TMMonth'), EXTRACT(week FROM d),
       EXTRACT(isodow FROM d), EXTRACT(isodow FROM d) >= 6, FALSE
FROM generate_series('2024-04-01'::date, '2026-12-31', '1 day') AS d
ON CONFLICT (fecha_key) DO NOTHING;


INSERT INTO gold.dim_hora
SELECT k, make_time(k/4, (k%4)*15, 0), k/4,
       CASE WHEN k/4 < 6 THEN 'madrugada' WHEN k/4 < 16 THEN 'solar'
            WHEN k/4 < 19 THEN 'tarde' ELSE 'noche' END
FROM generate_series(0,95) AS k
ON CONFLICT (hora_key) DO NOTHING;


INSERT INTO gold.dim_inversor (inversor_id, nombre, vigente_desde)
SELECT v.id, 'Subsistema ' || v.id, DATE '2025-07-01' FROM (VALUES (1),(2)) AS v(id)
ON CONFLICT (inversor_id, vigente_desde) DO NOTHING;


INSERT INTO gold.dim_tipo_evento (categoria, tipo) VALUES
  ('calendario','festivo'), ('calendario','examen'), ('calendario','fin_de_clases'),
  ('otro','sin_clasificar')
ON CONFLICT DO NOTHING;


INSERT INTO gold.dim_tarifa (operador, nivel_tension, tipo_usuario, cu_cop_kwh, vigente_desde, vigente_hasta, fuente)
SELECT 'EPM', 1, 'no_residencial', 850.00, m::date,
       (m + interval '1 month' - interval '1 day')::date,
       'PLACEHOLDER: reemplazar por el CU publicado'
FROM generate_series('2025-07-01'::date, '2026-07-01'::date, '1 month') AS m
ON CONFLICT DO NOTHING;
