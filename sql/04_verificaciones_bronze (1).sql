
-- V1. Inversores presentes y su rango de fechas
SELECT inverter, COUNT(*) AS filas,
       datetime(MIN(read_ts),'unixepoch') AS desde_utc, datetime(MAX(read_ts),'unixepoch') AS hasta_utc
FROM analog_measurements GROUP BY inverter;

-- V2. Zona horaria: hora UTC con mayor potencia solar media (si el pico cae cerca de 04 UTC, el sitio esta en UTC+8)
SELECT strftime('%H', read_ts, 'unixepoch') AS hora_utc, ROUND(AVG(pv1power), 1) AS pv_w_medio
FROM analog_measurements WHERE inverter = 1 AND pv1power IS NOT NULL
GROUP BY 1 ORDER BY 2 DESC LIMIT 3;

-- V3. A que hora UTC se reinicia el contador "de hoy" (si es 16 UTC, el dia del equipo es el de UTC+8)
WITH s AS (
  SELECT read_ts, pvgeneratenergytoday AS v,
         LAG(pvgeneratenergytoday) OVER (ORDER BY read_ts) AS prev
  FROM statistics WHERE inverter = 1 AND pvgeneratenergytoday IS NOT NULL
)
SELECT strftime('%H', read_ts, 'unixepoch') AS hora_utc_reinicio, COUNT(*) AS veces
FROM s WHERE prev > v + 0.5 GROUP BY 1 ORDER BY 2 DESC LIMIT 5;

-- V4. Conciliacion potencia vs contador (kWh por dia, aproximado: potencia media x 24 h)
WITH a AS (
  SELECT date(read_ts,'unixepoch','+8 hours') AS dia,
         ROUND(AVG(pv1power)     * 24 / 1000.0, 2) AS pv_kwh_integrado,
         ROUND(AVG(gridpowerw_a) * 24 / 1000.0, 2) AS red_kwh_integrado
  FROM analog_measurements WHERE inverter = 1 GROUP BY 1
), s AS (
  SELECT date(read_ts,'unixepoch','+8 hours') AS dia,
         MAX(pvgeneratenergytoday) AS pv_kwh_contador,
         MAX(loadconsumlinetday)   AS carga_red_kwh_contador,
         MAX(linechgenergytday)    AS bateria_carga_red_kwh_contador
  FROM statistics WHERE inverter = 1 GROUP BY 1
)
SELECT a.dia, a.pv_kwh_integrado, s.pv_kwh_contador,
       a.red_kwh_integrado, s.carga_red_kwh_contador, s.bateria_carga_red_kwh_contador
FROM a JOIN s USING (dia) ORDER BY a.dia LIMIT 30;

-- V5. Tabla context: claves del JSON, fuentes y descripciones mas frecuentes
SELECT DISTINCT j.key AS clave FROM context, json_each(context.value) AS j;
SELECT json_extract(value,'$.source') AS fuente, COUNT(*) AS registros FROM context GROUP BY 1;
SELECT substr(json_extract(value,'$.textual_description'),1,70) AS descripcion, COUNT(*) AS veces
FROM context GROUP BY 1 ORDER BY 2 DESC LIMIT 25;

-- V6. Coherencia de los contadores: la carga total no puede ser menor que la carga tomada de la red
SELECT COUNT(*) AS filas_incoherentes FROM statistics WHERE usedenergytoday < loadconsumlinetday - 0.05;

-- V7. Signos: valores negativos que romperian los CHECK (>= 0) de Gold (e_pv, e_carga, e_red)
SELECT SUM(pv1power < 0)      AS pv_negativos,
       SUM(outsumw < 0)       AS carga_negativos,
       SUM(gridpowerw_a < 0)  AS red_negativos,
       COUNT(*)               AS filas
FROM analog_measurements;

-- V8. Rango de fechas de context (dim_fecha cubre 2024-04-01 a 2026-12-31; fuera de ese rango fallan las FK de eventos)
SELECT date(MIN(start),'unixepoch','+8 hours') AS inicio_min,
       date(MAX("end"),'unixepoch','+8 hours') AS fin_max,
       SUM(start < strftime('%s','2024-04-01') OR "end" > strftime('%s','2027-01-01')) AS fuera_de_rango
FROM context;
