# Modelo dimensional y PostgreSQL

## Alcance
Esta carpeta complementa el trabajo del Taller 6: catálogo de indicadores, modelo dimensional, matriz bus, diccionario de datos, DDL y consultas SQL. También incorpora vistas listas para conectar Power BI y Grafana.


## Orden de ejecución en DBeaver
Conectarse a PostgreSQL y ejecutar cada archivo en este orden:

1. `00_silver_contrato.sql` — crea el contrato de tablas Silver.
2. `01_ddl.sql` — crea dimensiones y tablas de hechos Gold.
3. `07_datos_demo_sinteticos.sql` — opcional, solo para probar con datos sintéticos de junio de 2026.
4. `03_carga_gold.sql` — transforma Silver a Gold. Ejecutarlo después de cargar Silver real o demo.
5. `05_consumo_bi.sql` — crea vistas de consumo para Power BI y Grafana.
6. `06_catalogo_diccionario.sql` — registra indicadores y diccionario resumido.
7. `02_consultas.sql` — consultas analíticas entregables.

`04_verificaciones_bronze.sql` contiene consultas para ejecutar directamente en SQLite/Bronze, no en PostgreSQL.

## Conexión de Power BI
- Obtener host, puerto, base de datos y usuario de PostgreSQL del equipo.
- En Power BI Desktop: Obtener datos → PostgreSQL.
- Importar `bi.vw_powerbi_diario` y `bi.vw_powerbi_mensual`.
- Usar `fecha` como fecha y crear una tabla calendario propia en Power BI, relacionada 1:* con `vw_powerbi_diario[fecha]`.
- Medidas iniciales sugeridas:
  - Energía solar (kWh) = `SUM(vw_powerbi_diario[energia_solar_kwh])`
  - Energía de carga (kWh) = `SUM(vw_powerbi_diario[energia_carga_kwh])`
  - Energía red importada (kWh) = `SUM(vw_powerbi_diario[energia_red_importada_kwh])`
  - Ahorro neto (COP) = `SUM(vw_powerbi_diario[ahorro_neto_cop])`
  - Autosuficiencia (%) = `DIVIDE([Autoconsumo solar (kWh)],[Energía de carga (kWh)])`
- Para time intelligence, usar la tabla calendario marcada como tabla de fechas y `DATEADD`/`SAMEPERIODLASTYEAR` cuando exista cobertura suficiente.

## Conexión de Grafana
- Añadir PostgreSQL como Data source usando el mismo host/puerto/base de datos.
- Para series temporales, consultar `bi.vw_grafana_energia` y seleccionar `time` como columna temporal.
- Para tarjetas/medidores, consultar `bi.vw_grafana_estado_actual` o `bi.vw_grafana_kpi_24h`.
- Variable de dashboard sugerida: `inversor_id` con consulta `SELECT DISTINCT inversor_id FROM bi.vw_grafana_energia ORDER BY 1`.
- Alerta de demostración: `soc_prom_pct < 20` durante 5 minutos. Segundo ejemplo: `datos_validos_pct < 95`. Ajustar umbrales con diagnóstico real y no tratarlos como límites del fabricante.

## Modelo dimensional: grano
- `gold.fact_energia_intervalo`: una fila por inversor y comienzo de intervalo de 15 minutos. Proceso: medición de energía/potencia y estado de batería.
- `gold.fact_ahorro_diario`: una fila por inversor, día local y tarifa. Proceso: balance energético y estimación económica diaria.
- `gold.fact_evento_contexto`: una fila por evento de contexto de origen. Proceso: registro de eventos y anotaciones operativas.

## Matriz bus
| Proceso / Dimensión | Fecha | Hora | Inversor | Tarifa | Tipo evento |
|---|:---:|:---:|:---:|:---:|:---:|
| Lectura energética 15 min | X | X | X | X | |
| Balance y ahorro diario | X | | X | X | |
| Evento de contexto | X (inicio/fin) | | | | X |

## Dimensiones
- `dim_fecha`: fecha, año, trimestre, mes, semana ISO, día de semana, fin de semana y festivo.
- `dim_hora`: clave de intervalo de 15 minutos, hora y franja (madrugada/solar/tarde/noche). Es una dimensión construida por el equipo.
- `dim_inversor`: identificador, nombre y vigencia; preparada para cambios históricos tipo SCD 2, aunque el ETL debe cerrar la fila anterior al cambiar atributos.
- `dim_tarifa`: operador, nivel de tensión, tipo de usuario, tarifa COP/kWh y vigencia.
- `dim_tipo_evento`: categoría y tipo clasificado desde el JSON.

## Catálogo de indicadores (resumen)
| Indicador | Fórmula / unidad | Grano | Consumidor |
|---|---|---|---|
| Energía solar generada | SUM(e_pv_kwh), kWh | 15 min/día/mes | Dirección |
| Energía entregada a carga | SUM(e_carga_kwh), kWh | 15 min/día/mes | Dirección |
| Energía importada de red | SUM(e_red_kwh) o e_red_imp_kwh, kWh | 15 min/día | Dirección/mantenimiento |
| Disponibilidad | intervalos presentes / 96 × 100, % | Inversor/día | Mantenimiento |
| Datos válidos | SUM(n_validas)/SUM(n_lecturas) × 100, % | Inversor/periodo | Calidad |
| SOC promedio | AVG(soc_prom_pct), % | 15 min/día | Mantenimiento |
| Autosuficiencia estimada | autoconsumo/carga × 100, % | Inversor/día | Dirección |
| Ahorro neto estimado | costo contrafactual − costo importación, COP | Inversor/día | Dirección financiera |
| Intensidad de uso batería | descarga/carga × 100, % | Inversor/día | Mantenimiento |

Dos indicadores adicionales propios: autosuficiencia estimada e intensidad de uso de batería. La segunda no debe llamarse eficiencia de batería, porque no mide pérdidas de carga/descarga sincronizadas.

## Hallazgos y correcciones importantes antes de entregar
1. La tarifa `850 COP/kWh` en el DDL original está marcada como `PLACEHOLDER`: reemplazarla por tarifa documentada y citar fuente/periodo. No presentar los costos como reales mientras siga ese valor.
2. El DDL limita las fechas de `dim_fecha` y `dim_tarifa`. Verificar que cubran todas las fechas de Bronze antes de ejecutar la carga real.
3. La consulta de disponibilidad original divide filas presentes entre 96, pero no detecta los días/intervalos completamente ausentes. Usar `bi.vw_calidad_diaria` para un cálculo que genere el calendario entre mínimo y máximo por inversor. Para mayor rigor, ampliar calendario al rango completo esperado del dataset.
4. `gridpowerw_a` se interpreta como potencia importada. Validar unidad, signo y semántica en documentación y con la conciliación antes de publicar KPIs.
5. La energía de intervalo se estima como potencia promedio × 0,25 h. La fuente tiene lecturas aproximadamente cada 330 segundos; documentar que es una aproximación y comparar con los contadores diarios.
6. La fórmula de autoconsumo reparte proporcionalmente la descarga de batería según la fracción de carga de batería que vino de la red. Es un supuesto, no una medición directa de origen de electrones.
7. El archivo `04_verificaciones_bronze.sql` usa sintaxis SQLite (`strftime`, `json_each`, `datetime`); ejecutarlo en la base SQLite Bronze, no en PostgreSQL.
8. El SQL actual de carga Gold espera que el ETL real ya haya poblado las tres tablas Silver. Los scripts SQL por sí solos no descargan ni transforman el archivo Zenodo.

## Pregunta clásica fotovoltaica que no se calcula directamente
El Performance Ratio (PR) no se puede calcular correctamente sin irradiancia en el plano del generador (POA), temperatura de módulo y potencia nominal validada/condiciones de referencia. Propuesta: incorporar sensores POA y temperatura, documentar potencia instalada por inversor y calcular PR con datos sincronizados.

## Seguridad
Crear usuario PostgreSQL de solo lectura para Power BI/Grafana. No guardar contraseñas reales en GitHub; usar Secrets de Kubernetes o variables de entorno y un `.env.example` sin secretos.
