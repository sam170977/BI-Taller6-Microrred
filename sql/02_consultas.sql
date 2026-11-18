-- ===== Q1. Consultas sobre el campo JSON (operadores nativos @>, ?, ->>, jsonb_object_keys) =====
-- Q1a. Dias con un evento "festivo" (descripcion en el JSON) frente a los dias sin evento.

WITH dias_evento AS (
  SELECT DISTINCT d.fecha_key
  FROM gold.fact_evento_contexto e
  JOIN gold.dim_fecha d ON d.fecha_key BETWEEN e.fecha_inicio_key AND e.fecha_fin_key
  WHERE e.contexto->>'textual_description' ILIKE '%holiday%'
)
SELECT (de.fecha_key IS NOT NULL) AS dia_con_evento,
       COUNT(*)                          AS dias_inversor,
       ROUND(AVG(a.e_carga_kwh), 1)      AS kwh_carga_prom,
       ROUND(AVG(a.costo_evitado_cop), 0) AS ahorro_cop_prom
FROM gold.fact_ahorro_diario a
LEFT JOIN dias_evento de ON de.fecha_key = a.fecha_key
GROUP BY 1 ORDER BY 1;

-- Q1b. Registros de contexto por fuente y cuantos traen descripcion (operador ?)
SELECT contexto->>'source' AS fuente, COUNT(*) AS registros,
       COUNT(*) FILTER (WHERE contexto ? 'textual_description') AS con_descripcion
FROM gold.fact_evento_contexto
GROUP BY 1 ORDER BY registros DESC;

-- Q1c. Claves presentes en el JSON y registros ingresados a mano (operador @>)
SELECT k AS clave, COUNT(*) AS veces
FROM gold.fact_evento_contexto, jsonb_object_keys(contexto) AS k
GROUP BY k ORDER BY veces DESC;

SELECT COUNT(*) AS registros_manuales
FROM gold.fact_evento_contexto
WHERE contexto @> '{"source": "manual entry"}';

-- ===== Q2. Ahorro mensual, variacion frente al mes anterior (por dia) y acumulado =====
WITH m AS (
  SELECT i.inversor_id, d.anio, d.mes, COUNT(*) AS dias,
         SUM(a.costo_evitado_cop) AS ahorro_cop,
         SUM(a.ahorro_neto_cop)   AS ahorro_neto_cop,
         SUM(a.e_autoconsumo_kwh) AS kwh_autoconsumo
  FROM gold.fact_ahorro_diario a
  JOIN gold.dim_fecha d    USING (fecha_key)
  JOIN gold.dim_inversor i USING (inversor_key)
  GROUP BY 1,2,3
)
SELECT *,
       ROUND(ahorro_cop / dias, 0) AS ahorro_por_dia,
       ROUND(100 * ((ahorro_cop / dias)
         / NULLIF(LAG(ahorro_cop / dias) OVER w, 0) - 1), 1) AS var_pct_vs_mes_ant,
       SUM(ahorro_cop) OVER (PARTITION BY inversor_id ORDER BY anio, mes) AS ahorro_acumulado
FROM m
WINDOW w AS (PARTITION BY inversor_id ORDER BY anio, mes)
ORDER BY inversor_id, anio, mes;

-- ===== Q3. Los 3 mejores dias de ahorro de cada mes =====
SELECT * FROM (
  SELECT d.anio, d.mes, d.fecha, i.inversor_id, a.costo_evitado_cop,
         ROW_NUMBER() OVER (PARTITION BY d.anio, d.mes, i.inversor_id
                            ORDER BY a.costo_evitado_cop DESC) AS puesto
  FROM gold.fact_ahorro_diario a
  JOIN gold.dim_fecha d USING (fecha_key)
  JOIN gold.dim_inversor i USING (inversor_key)
) x WHERE puesto <= 3 ORDER BY anio, mes, inversor_id, puesto;

-- ===== Q4. Autosuficiencia solar diaria y media movil de 7 dias =====
WITH d AS (
  SELECT a.inversor_key, f.fecha,
         100 * a.e_autoconsumo_kwh / NULLIF(a.e_carga_kwh, 0) AS autosuf_pct
  FROM gold.fact_ahorro_diario a JOIN gold.dim_fecha f USING (fecha_key)
)
SELECT inversor_key, fecha, ROUND(autosuf_pct, 1) AS autosuf_pct,
       ROUND(AVG(autosuf_pct) OVER (PARTITION BY inversor_key ORDER BY fecha
             ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 1) AS autosuf_media_7d
FROM d ORDER BY inversor_key, fecha;

-- ===== Q5. Generacion y carga por franja horaria (estimacion intradia con potencias) =====
-- Es una estimacion con LEAST(pv, carga) por intervalo: no reemplaza el ahorro diario de los contadores.
SELECT h.franja,
       ROUND(SUM(f.e_pv_kwh), 1)    AS kwh_pv,
       ROUND(SUM(f.e_carga_kwh), 1) AS kwh_carga,
       ROUND(SUM(LEAST(f.e_pv_kwh, f.e_carga_kwh)), 1) AS kwh_carga_cubierta_por_sol_directo,
       ROUND(SUM(LEAST(f.e_pv_kwh, f.e_carga_kwh) * t.cu_cop_kwh), 0) AS valor_estimado_cop
FROM gold.fact_energia_intervalo f
JOIN gold.dim_hora h   USING (hora_key)
JOIN gold.dim_tarifa t USING (tarifa_key)
GROUP BY h.franja ORDER BY kwh_pv DESC;

-- ===== Q6. Sensibilidad del ahorro a la tarifa (escenarios -20 %, base, +20 %) =====
SELECT e.nombre AS escenario,
       ROUND(SUM(a.e_autoconsumo_kwh * t.cu_cop_kwh * e.factor), 0) AS ahorro_cop
FROM gold.fact_ahorro_diario a
JOIN gold.dim_tarifa t USING (tarifa_key)
CROSS JOIN (VALUES ('-20 %', 0.8), ('Base', 1.0), ('+20 %', 1.2)) AS e(nombre, factor)
GROUP BY e.nombre, e.factor ORDER BY e.factor;

-- ===== Q7. Disponibilidad y % de datos validos por inversor y dia =====
SELECT i.inversor_id, d.fecha,
       ROUND(100.0 * COUNT(*) FILTER (WHERE f.n_lecturas > 0) / 96, 1) AS disponibilidad_pct,
       ROUND(100.0 * SUM(f.n_validas) / NULLIF(SUM(f.n_lecturas), 0), 1) AS validos_pct
FROM gold.fact_energia_intervalo f
JOIN gold.dim_fecha d    USING (fecha_key)
JOIN gold.dim_inversor i USING (inversor_key)
GROUP BY 1, 2 ORDER BY 1, 2;

-- ===== Q8. Conciliacion: energia solar integrada desde potencias frente al contador diario =====
SELECT i.inversor_id, d.fecha, a.e_pv_kwh AS pv_contador_kwh,
       ROUND(SUM(f.e_pv_kwh), 3) AS pv_integrado_kwh,
       ROUND(100 * SUM(f.e_pv_kwh) / NULLIF(a.e_pv_kwh, 0), 1) AS pct_integrado_vs_contador
FROM gold.fact_ahorro_diario a
JOIN gold.fact_energia_intervalo f ON f.inversor_key = a.inversor_key AND f.fecha_key = a.fecha_key
JOIN gold.dim_fecha d    ON d.fecha_key = a.fecha_key
JOIN gold.dim_inversor i ON i.inversor_key = a.inversor_key
GROUP BY i.inversor_id, d.fecha, a.e_pv_kwh
ORDER BY i.inversor_id, d.fecha;
