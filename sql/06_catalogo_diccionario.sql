-- 06_catalogo_diccionario.sql
-- Catalogo de indicadores y diccionario de datos resumido para documentar el modelo.
CREATE SCHEMA IF NOT EXISTS gobierno;

CREATE TABLE IF NOT EXISTS gobierno.catalogo_indicador (
  indicador_id TEXT PRIMARY KEY,
  nombre TEXT NOT NULL,
  definicion TEXT NOT NULL,
  formula TEXT NOT NULL,
  unidad TEXT NOT NULL,
  granularidad TEXT NOT NULL,
  fuente TEXT NOT NULL,
  consumidor TEXT NOT NULL,
  umbral_meta TEXT,
  limitacion TEXT
);

INSERT INTO gobierno.catalogo_indicador
(indicador_id,nombre,definicion,formula,unidad,granularidad,fuente,consumidor,umbral_meta,limitacion)
VALUES
('E_SOLAR','Energia solar generada','Energia producida por los paneles solares.','SUM(e_pv_kwh)','kWh','15 min / dia / mes / periodo','analog_measurements.pv1power; statistics.pvgeneratenergytoday','Direccion / mantenimiento','>= 0','La energia de 15 min es estimada desde potencia media; preferir contador diario para cierres.'),
('E_CARGA','Energia entregada a la carga','Energia consumida por las cargas conectadas al inversor.','SUM(e_carga_kwh)','kWh','15 min / dia / mes / periodo','analog_measurements.outsumw; statistics.usedenergytoday','Direccion','>= 0','Verificar significado/unidad de la variable en documentacion del dataset.'),
('E_RED','Energia importada de red','Energia tomada de la red publica.','SUM(e_red_kwh) en intervalo; e_red_imp_kwh en resumen diario','kWh','15 min / dia / mes / periodo','analog_measurements.gridpowerw_a; statistics.loadconsumlinetday + linechgenergytday','Direccion / mantenimiento','>= 0','La interpretacion de gridpowerw_a como importacion debe validarse por signo y documentacion.'),
('DISP','Disponibilidad de registro','Porcentaje de intervalos con al menos una lectura frente a 96 intervalos esperados por dia.','intervalos_presentes / 96 * 100','%','inversor / dia','gold.fact_energia_intervalo','Mantenimiento / calidad','Meta sugerida >= 95%','Requiere calendario completo; usar bi.vw_calidad_diaria.'),
('VALIDOS','Porcentaje de datos validos','Proporcion de lecturas que cumplen reglas de calidad.','SUM(n_validas) / SUM(n_lecturas) * 100','%','inversor / dia / periodo','silver.lectura_15min','Ingenieria de datos','Meta sugerida >= 98%','No confundir con disponibilidad: una mide presencia y otra validez.'),
('SOC','Estado de carga promedio','Nivel promedio de carga de la bateria.','AVG(soc_prom_pct)','%','15 min / hora / dia','analog_measurements.battsoc','Mantenimiento','Alerta < 20% (umbral de demostracion)','No sustituye limites recomendados por fabricante.'),
('AUTOC','Autoconsumo solar estimado','Parte de la carga que se estima cubierta con energia solar propia.','e_autoconsumo_kwh','kWh','inversor / dia / mes','statistics + regla ETL documentada','Direccion','>= 0','Estimacion depende del reparto proporcional de energia de bateria cargada desde red.'),
('AUTOSUF','Autosuficiencia energetica estimada','Proporcion de la carga cubierta por autoconsumo solar estimado.','e_autoconsumo_kwh / e_carga_kwh * 100','%','inversor / dia / mes','gold.fact_ahorro_diario','Direccion','Seguimiento de tendencia','No equivale a independencia total de red.'),
('AHORRO','Ahorro neto estimado','Diferencia entre costo contrafactual y costo de importacion calculado.','costo_contrafactual_cop - costo_importacion_cop','COP','inversor / dia / mes','gold.fact_ahorro_diario + gold.dim_tarifa','Direccion financiera','>= 0 deseable','Depende de tarifa y supuestos; la tarifa 850 COP/kWh del script inicial es PLACEHOLDER y debe sustituirse.'),
('BAT_CICLO','Intensidad de uso de bateria','Energia descargada respecto a energia cargada en el periodo.','SUM(e_bat_desc_kwh) / SUM(e_bat_carga_kwh) * 100','%','inversor / dia / mes','statistics.batdischgenergytoday; batchgenergytoday','Mantenimiento / direccion','Analizar tendencia','No es eficiencia round-trip: faltan mediciones sincronizadas de perdidas y energia util.')
ON CONFLICT (indicador_id) DO UPDATE SET
 nombre=EXCLUDED.nombre, definicion=EXCLUDED.definicion, formula=EXCLUDED.formula,
 unidad=EXCLUDED.unidad, granularidad=EXCLUDED.granularidad, fuente=EXCLUDED.fuente,
 consumidor=EXCLUDED.consumidor, umbral_meta=EXCLUDED.umbral_meta, limitacion=EXCLUDED.limitacion;

-- Diccionario resumido: consultar informacion tecnica de tablas/columnas.
CREATE TABLE IF NOT EXISTS gobierno.diccionario_datos (
  esquema TEXT NOT NULL,
  tabla TEXT NOT NULL,
  columna TEXT NOT NULL,
  descripcion TEXT NOT NULL,
  unidad TEXT,
  origen_transformacion TEXT,
  PRIMARY KEY (esquema, tabla, columna)
);

INSERT INTO gobierno.diccionario_datos VALUES
('gold','fact_energia_intervalo','ts_inicio','Inicio del intervalo de 15 minutos','timestamp UTC','analog_measurements.read_ts agrupado por cuarto de hora'),
('gold','fact_energia_intervalo','e_pv_kwh','Energia solar estimada en el intervalo','kWh','AVG(pv1power) W / 1000 * 0.25 h'),
('gold','fact_energia_intervalo','e_carga_kwh','Energia entregada a carga estimada','kWh','AVG(outsumw) W / 1000 * 0.25 h'),
('gold','fact_energia_intervalo','e_red_kwh','Energia de red estimada','kWh','AVG(gridpowerw_a) W / 1000 * 0.25 h; validar signo y significado'),
('gold','fact_energia_intervalo','soc_prom_pct','Estado de carga promedio de bateria','%','AVG(battsoc)'),
('gold','fact_energia_intervalo','n_lecturas','Numero de lecturas recibidas','conteo','COUNT(*) en intervalo'),
('gold','fact_energia_intervalo','n_validas','Lecturas que cumplen reglas de calidad','conteo','COUNT(*) con variables obligatorias presentes y dentro de rango'),
('gold','fact_ahorro_diario','e_autoconsumo_kwh','Autoconsumo solar estimado diario','kWh','Carga menos red directa y fraccion estimada de descarga atribuible a carga desde red'),
('gold','fact_ahorro_diario','ahorro_neto_cop','Ahorro neto estimado','COP','Costo contrafactual menos costo de importacion'),
('gold','fact_evento_contexto','contexto','Registro de contexto original en JSONB','JSON','silver.contexto.valor sin perder estructura')
ON CONFLICT (esquema,tabla,columna) DO UPDATE SET
 descripcion=EXCLUDED.descripcion, unidad=EXCLUDED.unidad,
 origen_transformacion=EXCLUDED.origen_transformacion;
