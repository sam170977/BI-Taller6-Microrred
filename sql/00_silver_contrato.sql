
CREATE SCHEMA IF NOT EXISTS silver;

-- Origen: analog_measurements (potencias en W, una lectura cada ~330 s), agregadas a 15 min.
-- Una energia queda NULL si en ese intervalo no hubo ninguna lectura valida (NULL no es cero).
CREATE TABLE IF NOT EXISTS silver.lectura_15min (
  inversor_id   INT NOT NULL,                 -- inverter (1 o 2)
  ts_inicio     TIMESTAMPTZ NOT NULL,         -- inicio del intervalo, UTC (from read_ts)
  e_pv_kwh      NUMERIC(12,4),                -- AVG(pv1power) / 1000 * 0,25 h
  e_carga_kwh   NUMERIC(12,4),                -- AVG(outsumw) / 1000 * 0,25 h
  e_red_kwh     NUMERIC(12,4),                -- AVG(gridpowerw_a) / 1000 * 0,25 h (hipotesis: potencia tomada de la red)
  soc_prom_pct  NUMERIC(5,2),                 -- AVG(battsoc)
  n_lecturas    SMALLINT NOT NULL,            -- lecturas del intervalo
  n_validas     SMALLINT NOT NULL,            -- lecturas con pv1power, outsumw y gridpowerw_a no nulos y en rango
  PRIMARY KEY (inversor_id, ts_inicio)
);

-- Origen: statistics (contadores "de hoy", en kWh). Un valor por inversor y dia local = MAX del dia.
CREATE TABLE IF NOT EXISTS silver.contador_diario (
  inversor_id            INT  NOT NULL,
  fecha_local            DATE NOT NULL,           -- dia en la hora del sitio (UTC+8), no en hora de Bogota
  pv_kwh                 NUMERIC(10,3) NOT NULL,  -- MAX(pvgeneratenergytoday)
  carga_kwh              NUMERIC(10,3) NOT NULL,  -- MAX(usedenergytoday)
  carga_red_kwh          NUMERIC(10,3) NOT NULL,  -- MAX(loadconsumlinetday): carga alimentada desde la red
  bateria_carga_kwh      NUMERIC(10,3) NOT NULL,  -- MAX(batchgenergytoday)
  bateria_desc_kwh       NUMERIC(10,3) NOT NULL,  -- MAX(batdischgenergytoday)
  bateria_carga_red_kwh  NUMERIC(10,3) NOT NULL,  -- MAX(linechgenergytday): bateria cargada desde la red
  n_lecturas             SMALLINT NOT NULL,
  PRIMARY KEY (inversor_id, fecha_local)
);

-- Origen: context (25.178 filas). Las epocas start/end/recorded estan en segundos.
CREATE TABLE IF NOT EXISTS silver.contexto (
  id_origen     INT PRIMARY KEY,              -- id
  registrado_ts TIMESTAMPTZ,                  -- to_timestamp(recorded)
  inicio_ts     TIMESTAMPTZ NOT NULL,         -- to_timestamp(start)
  fin_ts        TIMESTAMPTZ NOT NULL,         -- to_timestamp(end)
  valor         JSONB NOT NULL                -- value (texto JSON de Bronze convertido a JSONB)
);
