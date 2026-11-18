-- 07_datos_demo_sinteticos.sql
-- SOLO DEMOSTRACION: genera telemetria sintetica de 2 inversores durante junio de 2026.

INSERT INTO silver.lectura_15min
(inversor_id, ts_inicio, e_pv_kwh, e_carga_kwh, e_red_kwh, soc_prom_pct, n_lecturas, n_validas)
SELECT inv,
       ((d::date + make_time(h, m, 0)) AT TIME ZONE 'Etc/GMT-8') AS ts_utc,
       ROUND((GREATEST(0, SIN(((h + m/60.0) - 6) * PI()/12.0)) * (1.15 + inv*0.12))::numeric,4),
       ROUND((0.55 + inv*0.08 + CASE WHEN h BETWEEN 18 AND 22 THEN 0.25 ELSE 0 END)::numeric,4),
       ROUND((CASE WHEN h < 6 OR h > 18 THEN 0.20 + inv*0.04 ELSE 0.04 END)::numeric,4),
       ROUND((72 - (d::date - DATE '2026-06-01')*0.15 + inv*2 + CASE WHEN h BETWEEN 10 AND 15 THEN 5 ELSE 0 END)::numeric,2),
       3, 3
FROM generate_series(DATE '2026-06-01', DATE '2026-06-30', INTERVAL '1 day') d
CROSS JOIN generate_series(0,23) h
CROSS JOIN (VALUES (0),(15),(30),(45)) mm(m)
CROSS JOIN (VALUES (1),(2)) iv(inv)
ON CONFLICT (inversor_id, ts_inicio) DO NOTHING;

INSERT INTO silver.contador_diario
(inversor_id, fecha_local, pv_kwh, carga_kwh, carga_red_kwh, bateria_carga_kwh,
 bateria_desc_kwh, bateria_carga_red_kwh, n_lecturas)
SELECT inv, d::date,
       ROUND((18 + inv*2 + 2*SIN(EXTRACT(DOY FROM d)*PI()/15))::numeric,3),
       ROUND((19 + inv*1.5)::numeric,3),
       ROUND((5 + inv*0.7)::numeric,3),
       ROUND((6 + inv*0.5)::numeric,3),
       ROUND((5 + inv*0.4)::numeric,3),
       ROUND((1.0 + inv*0.2)::numeric,3),
       288
FROM generate_series(DATE '2026-06-01', DATE '2026-06-30', INTERVAL '1 day') d
CROSS JOIN (VALUES (1),(2)) iv(inv)
ON CONFLICT (inversor_id, fecha_local) DO NOTHING;

INSERT INTO silver.contexto(id_origen, registrado_ts, inicio_ts, fin_ts, valor)
VALUES
(900001, TIMESTAMPTZ '2026-06-05 08:00:00+08', TIMESTAMPTZ '2026-06-05 08:00:00+08',
 TIMESTAMPTZ '2026-06-05 18:00:00+08', '{"source":"manual entry","textual_description":"exam period","event":"exam"}'::jsonb),
(900002, TIMESTAMPTZ '2026-06-15 00:00:00+08', TIMESTAMPTZ '2026-06-15 00:00:00+08',
 TIMESTAMPTZ '2026-06-15 23:59:00+08', '{"source":"calendar","textual_description":"holiday","event":"holiday"}'::jsonb)
ON CONFLICT (id_origen) DO NOTHING;

-- Despues de este archivo:
-- 1) Ejecutar 03_carga_gold.sql
-- 2) Ejecutar 05_consumo_bi.sql
-- 3) Validar SELECT COUNT(*) FROM bi.vw_powerbi_diario;
-- 4) Validar SELECT * FROM bi.vw_grafana_estado_actual;
