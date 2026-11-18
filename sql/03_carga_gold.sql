-- Carga idempotente de Gold desde Silver (contrato en 00_silver_contrato.sql).
-- Hora del sitio: Correr dos veces deja el mismo resultado.

-- 1) Energia por intervalo
INSERT INTO gold.fact_energia_intervalo
SELECT i.inversor_key, s.ts_inicio,
       to_char(s.ts_inicio AT TIME ZONE 'Etc/GMT-8', 'YYYYMMDD')::int,
       (EXTRACT(hour FROM s.ts_inicio AT TIME ZONE 'Etc/GMT-8') * 4
        + FLOOR(EXTRACT(minute FROM s.ts_inicio AT TIME ZONE 'Etc/GMT-8') / 15))::smallint,
       t.tarifa_key,
       s.e_pv_kwh, s.e_carga_kwh, s.e_red_kwh, s.soc_prom_pct, s.n_lecturas, s.n_validas
FROM silver.lectura_15min s
JOIN gold.dim_inversor i ON i.inversor_id = s.inversor_id
     AND (s.ts_inicio AT TIME ZONE 'Etc/GMT-8')::date BETWEEN i.vigente_desde AND i.vigente_hasta
JOIN gold.dim_tarifa t ON t.operador = 'EPM' AND t.nivel_tension = 1 AND t.tipo_usuario = 'no_residencial'
     AND (s.ts_inicio AT TIME ZONE 'Etc/GMT-8')::date BETWEEN t.vigente_desde AND t.vigente_hasta
ON CONFLICT (inversor_key, ts_inicio) DO UPDATE SET
  e_pv_kwh = EXCLUDED.e_pv_kwh, e_carga_kwh = EXCLUDED.e_carga_kwh, e_red_kwh = EXCLUDED.e_red_kwh,
  soc_prom_pct = EXCLUDED.soc_prom_pct, n_lecturas = EXCLUDED.n_lecturas, n_validas = EXCLUDED.n_validas;

-- 2) Ahorro diario desde los contadores del inversor.
-- Autoconsumo solar = carga - carga desde la red - descarga de bateria que vino de la red.
-- La parte de la descarga de origen red se reparte con la proporcion carga_red / carga_total de la bateria.
INSERT INTO gold.fact_ahorro_diario
  (inversor_key, fecha_key, tarifa_key, e_pv_kwh, e_carga_kwh, e_red_carga_kwh, e_red_bateria_kwh,
   e_bat_carga_kwh, e_bat_desc_kwh, e_autoconsumo_kwh,
   costo_evitado_cop, costo_contrafactual_cop, costo_importacion_cop)
SELECT i.inversor_key, to_char(c.fecha_local, 'YYYYMMDD')::int, t.tarifa_key,
       c.pv_kwh, c.carga_kwh, c.carga_red_kwh, c.bateria_carga_red_kwh,
       c.bateria_carga_kwh, c.bateria_desc_kwh, a.autoconsumo,
       a.autoconsumo * t.cu_cop_kwh,
       c.carga_kwh * t.cu_cop_kwh,
       (c.carga_red_kwh + c.bateria_carga_red_kwh) * t.cu_cop_kwh
FROM silver.contador_diario c
JOIN gold.dim_inversor i ON i.inversor_id = c.inversor_id
     AND c.fecha_local BETWEEN i.vigente_desde AND i.vigente_hasta
JOIN gold.dim_tarifa t ON t.operador = 'EPM' AND t.nivel_tension = 1 AND t.tipo_usuario = 'no_residencial'
     AND c.fecha_local BETWEEN t.vigente_desde AND t.vigente_hasta
CROSS JOIN LATERAL (
  SELECT GREATEST(c.carga_kwh - c.carga_red_kwh
                  - COALESCE(c.bateria_desc_kwh * c.bateria_carga_red_kwh / NULLIF(c.bateria_carga_kwh, 0), 0), 0)
) AS a(autoconsumo)
ON CONFLICT (inversor_key, fecha_key, tarifa_key) DO UPDATE SET
  e_pv_kwh = EXCLUDED.e_pv_kwh, e_carga_kwh = EXCLUDED.e_carga_kwh,
  e_red_carga_kwh = EXCLUDED.e_red_carga_kwh, e_red_bateria_kwh = EXCLUDED.e_red_bateria_kwh,
  e_bat_carga_kwh = EXCLUDED.e_bat_carga_kwh, e_bat_desc_kwh = EXCLUDED.e_bat_desc_kwh,
  e_autoconsumo_kwh = EXCLUDED.e_autoconsumo_kwh,
  costo_evitado_cop = EXCLUDED.costo_evitado_cop,
  costo_contrafactual_cop = EXCLUDED.costo_contrafactual_cop,
  costo_importacion_cop = EXCLUDED.costo_importacion_cop;

-- 3) Eventos de contexto (JSON). Reglas de clasificacion provisionales: revisar con la verificacion V5.
INSERT INTO gold.fact_evento_contexto
  (id_origen, tipo_evento_key, fecha_inicio_key, fecha_fin_key, ts_inicio, ts_fin, registrado_ts, contexto)
SELECT x.id_origen, te.tipo_evento_key,
       to_char(x.inicio_ts AT TIME ZONE 'Etc/GMT-8', 'YYYYMMDD')::int,
       to_char(x.fin_ts    AT TIME ZONE 'Etc/GMT-8', 'YYYYMMDD')::int,
       x.inicio_ts, x.fin_ts, x.registrado_ts, x.valor
FROM (
  SELECT s.*,
         CASE WHEN s.valor->>'textual_description' ILIKE '%holiday%'  THEN 'festivo'
              WHEN s.valor->>'textual_description' ILIKE '%exam%'     THEN 'examen'
              WHEN s.valor->>'textual_description' ILIKE '%last day%' THEN 'fin_de_clases'
              ELSE 'sin_clasificar' END AS tipo
  FROM silver.contexto s
) x
JOIN gold.dim_tipo_evento te ON te.tipo = x.tipo
ON CONFLICT (id_origen) DO UPDATE SET
  tipo_evento_key = EXCLUDED.tipo_evento_key, fecha_inicio_key = EXCLUDED.fecha_inicio_key,
  fecha_fin_key = EXCLUDED.fecha_fin_key, ts_inicio = EXCLUDED.ts_inicio, ts_fin = EXCLUDED.ts_fin,
  registrado_ts = EXCLUDED.registrado_ts, contexto = EXCLUDED.contexto;

-- 4) Marca de festivo en la dimension de fecha, derivada del contexto
UPDATE gold.dim_fecha d SET es_festivo = TRUE
WHERE EXISTS (SELECT 1 FROM gold.fact_evento_contexto e
              JOIN gold.dim_tipo_evento t USING (tipo_evento_key)
              WHERE t.tipo = 'festivo' AND d.fecha_key BETWEEN e.fecha_inicio_key AND e.fecha_fin_key);
