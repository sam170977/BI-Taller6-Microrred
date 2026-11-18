-- 05_consumo_bi.sql
-- Vistas de consumo para Power BI (analitica) y Grafana (operacion).
-- Ejecutar despues de 01_ddl.sql y 03_carga_gold.sql.
-- Zona horaria del equipo fuente documentada en el proyecto: UTC+8 (validar con V2/V3).

CREATE SCHEMA IF NOT EXISTS bi;

-- Power BI: detalle diario por inversor. Una fila por inversor-fecha-tarifa.
CREATE OR REPLACE VIEW bi.vw_powerbi_diario AS
SELECT
    f.fecha,
    f.anio, f.trimestre, f.mes, f.nombre_mes,
    i.inversor_id, i.nombre AS inversor,
    t.operador, t.cu_cop_kwh AS tarifa_cop_kwh,
    a.e_pv_kwh AS energia_solar_kwh,
    a.e_carga_kwh AS energia_carga_kwh,
    a.e_red_carga_kwh AS energia_red_carga_kwh,
    a.e_red_bateria_kwh AS energia_red_bateria_kwh,
    a.e_red_imp_kwh AS energia_red_importada_kwh,
    a.e_bat_carga_kwh AS energia_bateria_cargada_kwh,
    a.e_bat_desc_kwh AS energia_bateria_descargada_kwh,
    a.e_autoconsumo_kwh AS autoconsumo_solar_kwh,
    ROUND(100.0 * a.e_autoconsumo_kwh / NULLIF(a.e_carga_kwh,0),2) AS autosuficiencia_pct,
    a.costo_evitado_cop,
    a.costo_contrafactual_cop,
    a.costo_importacion_cop,
    a.ahorro_neto_cop
FROM gold.fact_ahorro_diario a
JOIN gold.dim_fecha f USING (fecha_key)
JOIN gold.dim_inversor i USING (inversor_key)
JOIN gold.dim_tarifa t USING (tarifa_key);

-- Power BI: resumen mensual para tendencias, comparativos y medidas DAX.
CREATE OR REPLACE VIEW bi.vw_powerbi_mensual AS
SELECT
    f.anio, f.mes, f.nombre_mes,
    i.inversor_id, i.nombre AS inversor,
    SUM(a.e_pv_kwh) AS energia_solar_kwh,
    SUM(a.e_carga_kwh) AS energia_carga_kwh,
    SUM(a.e_red_imp_kwh) AS energia_red_importada_kwh,
    SUM(a.e_autoconsumo_kwh) AS autoconsumo_solar_kwh,
    SUM(a.costo_evitado_cop) AS costo_evitado_cop,
    SUM(a.ahorro_neto_cop) AS ahorro_neto_cop
FROM gold.fact_ahorro_diario a
JOIN gold.dim_fecha f USING (fecha_key)
JOIN gold.dim_inversor i USING (inversor_key)
GROUP BY f.anio, f.mes, f.nombre_mes, i.inversor_id, i.nombre;

-- Grafana: serie temporal de potencia/energia por intervalo.
-- El campo time es el timestamp que Grafana reconoce como eje temporal.
CREATE OR REPLACE VIEW bi.vw_grafana_energia AS
SELECT
    f.ts_inicio AS time,
    i.inversor_id,
    i.nombre AS inversor,
    f.e_pv_kwh,
    f.e_carga_kwh,
    f.e_red_kwh,
    f.soc_prom_pct,
    f.n_lecturas,
    f.n_validas,
    ROUND(100.0 * f.n_validas / NULLIF(f.n_lecturas,0),2) AS datos_validos_pct
FROM gold.fact_energia_intervalo f
JOIN gold.dim_inversor i USING (inversor_key);

-- Grafana: estado mas reciente disponible por inversor.
CREATE OR REPLACE VIEW bi.vw_grafana_estado_actual AS
SELECT DISTINCT ON (i.inversor_id)
    i.inversor_id,
    i.nombre AS inversor,
    f.ts_inicio AS ultima_lectura,
    f.e_pv_kwh,
    f.e_carga_kwh,
    f.e_red_kwh,
    f.soc_prom_pct,
    f.n_lecturas,
    f.n_validas,
    ROUND(100.0 * f.n_validas / NULLIF(f.n_lecturas,0),2) AS datos_validos_pct,
    CASE
      WHEN f.soc_prom_pct IS NULL THEN 'SIN_DATO'
      WHEN f.soc_prom_pct < 20 THEN 'BATERIA_BAJA'
      WHEN f.soc_prom_pct > 95 THEN 'BATERIA_ALTA'
      ELSE 'NORMAL'
    END AS estado_bateria
FROM gold.fact_energia_intervalo f
JOIN gold.dim_inversor i USING (inversor_key)
ORDER BY i.inversor_id, f.ts_inicio DESC;

-- Grafana: agregacion de los ultimos 24h, util para Stat/Gauge.
CREATE OR REPLACE VIEW bi.vw_grafana_kpi_24h AS
SELECT
    i.inversor_id,
    i.nombre AS inversor,
    SUM(f.e_pv_kwh) AS solar_24h_kwh,
    SUM(f.e_carga_kwh) AS carga_24h_kwh,
    SUM(f.e_red_kwh) AS red_24h_kwh,
    ROUND(100.0 * SUM(f.n_validas) / NULLIF(SUM(f.n_lecturas),0),2) AS datos_validos_24h_pct,
    MAX(f.ts_inicio) AS ultima_lectura
FROM gold.fact_energia_intervalo f
JOIN gold.dim_inversor i USING (inversor_key)
WHERE f.ts_inicio >= NOW() - INTERVAL '24 hours'
GROUP BY i.inversor_id, i.nombre;

-- Correccion de disponibilidad: cuenta intervalos faltantes respecto a 96 intervalos/dia.
-- No usar COUNT(*)/96 sobre la tabla de hechos porque omite dias/intervalos ausentes.
CREATE OR REPLACE VIEW bi.vw_calidad_diaria AS
WITH limites AS (
  SELECT inversor_key, MIN(fecha_key) AS min_fecha, MAX(fecha_key) AS max_fecha
  FROM gold.fact_energia_intervalo GROUP BY inversor_key
),
calendario AS (
  SELECT l.inversor_key, d.fecha_key, d.fecha
  FROM limites l
  JOIN gold.dim_fecha d ON d.fecha_key BETWEEN l.min_fecha AND l.max_fecha
),
resumen AS (
  SELECT inversor_key, fecha_key,
         COUNT(*) AS intervalos_presentes,
         SUM(n_lecturas) AS lecturas_totales,
         SUM(n_validas) AS lecturas_validas
  FROM gold.fact_energia_intervalo
  GROUP BY inversor_key, fecha_key
)
SELECT i.inversor_id, c.fecha,
       COALESCE(r.intervalos_presentes,0) AS intervalos_presentes,
       ROUND(100.0 * COALESCE(r.intervalos_presentes,0) / 96,2) AS disponibilidad_intervalos_pct,
       ROUND(100.0 * r.lecturas_validas / NULLIF(r.lecturas_totales,0),2) AS datos_validos_pct
FROM calendario c
JOIN gold.dim_inversor i USING (inversor_key)
LEFT JOIN resumen r USING (inversor_key, fecha_key);

-- Permisos sugeridos: crear un usuario de solo lectura para las herramientas BI.
-- Ejecutar como administrador, sustituyendo la clave fuera del repositorio:
-- CREATE ROLE bi_lectura LOGIN PASSWORD 'CAMBIAR_FUERA_DEL_REPO';
-- GRANT CONNECT ON DATABASE nombre_base TO bi_lectura;
-- GRANT USAGE ON SCHEMA gold, bi TO bi_lectura;
-- GRANT SELECT ON ALL TABLES IN SCHEMA gold, bi TO bi_lectura;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA gold, bi GRANT SELECT ON TABLES TO bi_lectura;
