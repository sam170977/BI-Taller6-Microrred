-- 01b_parche_vigencias.sql

-- 1) Extender la version del inversor hasta el inicio de dim_fecha.
UPDATE gold.dim_inversor i
SET vigente_desde = DATE '2024-04-01'
WHERE i.vigente_desde = DATE '2025-07-01'
  AND NOT EXISTS (SELECT 1 FROM gold.dim_inversor x
                  WHERE x.inversor_id = i.inversor_id AND x.vigente_desde < DATE '2025-07-01');

-- 2) Completar tarifas faltantes (2024-04..2025-06 y 2026-08..2026-12).
INSERT INTO gold.dim_tarifa (operador, nivel_tension, tipo_usuario, cu_cop_kwh, vigente_desde, vigente_hasta, fuente)
SELECT 'EPM', 1, 'no_residencial', 850.00, m::date,
       (m + interval '1 month' - interval '1 day')::date,
       'PLACEHOLDER: reemplazar por el CU publicado'
FROM generate_series('2024-04-01'::date, '2026-12-01'::date, '1 month') AS m
ON CONFLICT DO NOTHING;

-- Verificacion: debe devolver 0 filas.
SELECT d.fecha FROM gold.dim_fecha d
WHERE NOT EXISTS (SELECT 1 FROM gold.dim_tarifa t
                  WHERE d.fecha BETWEEN t.vigente_desde AND t.vigente_hasta);
