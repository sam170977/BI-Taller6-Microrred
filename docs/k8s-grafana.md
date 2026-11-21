# Docker, Kubernetes, Grafana y simulador (texto base para el informe)

## 1. Contenedores (K.1)
| Imagen | Origen | Justificación |
|---|---|---|
| `microrred/etl:1.0.0` | `etl/Dockerfile` (contexto = raíz del repo) | `python:3.12-slim-bookworm`: `sqlite3` ya viene en la librería estándar, solo se añade `psycopg[binary]`. El `.sqlite` (Bronze) **no** va en la imagen: se monta en solo lectura en `/data`. Ejecuta `etl_bronze_silver.py` y luego `sql/03_carga_gold.sql` (ambos idempotentes). |
| `microrred/simulador:1.0.0` | `simulador/Dockerfile` | Misma base (~45 MB comprimida). Se descartó Alpine por fricción de musl con wheels binarios. Usuario no-root (UID 10001). |
| `postgres:16.4`, `grafana/grafana-oss:11.3.0` | Oficiales | Versión fija, sin `latest`. |

`docker-compose.yml` levanta los tres servicios para desarrollo local (perfil `etl` para la carga histórica). Usa los **mismos** archivos de `sql/` y `grafana/` que Kubernetes.

## 2. Clúster local (K.2)
**kind**, un nodo. Se crea y se destruye con un comando, no requiere VM (a diferencia de minikube) y permite montar la carpeta `data/` en el nodo para el ETL. Las imágenes propias llegan con `kind load docker-image` (no hay registry), por eso `imagePullPolicy: IfNotPresent`.

## 3. Objeto de Kubernetes por necesidad (K.3)
| Necesidad | Objeto | Por qué éste y no otro |
|---|---|---|
| Aislar el proyecto | `Namespace microrred-bi` | Agrupa todo y permite borrarlo junto. |
| BD que no pierde datos | `StatefulSet postgres` + `volumeClaimTemplates` (PVC 5 Gi) + Service headless | Identidad y volumen estables por pod; un Deployment no los garantiza. `PGDATA` en subcarpeta para evitar `lost+found`. |
| Esquema listo al primer arranque | `ConfigMap postgres-init` montado en `/docker-entrypoint-initdb.d` | Ejecuta en orden `00_silver_contrato`, `01_ddl`, `02_operativo`, `05_consumo_bi`, `06_roles.sh`. Se genera con Kustomize desde `sql/` (misma fuente que el equipo versiona). |
| Grafana siempre disponible | `Deployment grafana` + provisioning | Es *stateless*: su configuración sale de ConfigMaps, así que si el pod muere vuelve idéntico y sin tocar la interfaz. |
| Tablero y fuente al iniciar | `ConfigMap`s `grafana-datasources`, `-dashboard-provider`, `-alerting`, `-dashboards` | Provisioning por archivos (lo que exige la nota del taller). |
| Credenciales fuera del código | `Secret bi-credentials` | Lo crean `scripts/up.*` desde `.env` (ignorado por git); en el repo solo `k8s/secret.example.yaml`. Limitación: base64 no es cifrado; en producción, cifrado en reposo o gestor externo. |
| Config separada del código | `ConfigMap bi-config` | Escenario del simulador, intervalos, ruta del `.sqlite`; se cambian con `kubectl patch` sin reconstruir imágenes. |
| Servicios se encuentran por nombre | `Service postgres` (ClusterIP) | ETL, simulador y Grafana usan `postgres:5432`. |
| Carga histórica una vez | `Job etl-carga-historica` | Corre, termina y deja logs y estado `Complete` como evidencia. |
| Datos nuevos periódicos | `CronJob simulador` (`*/1 * * * *`, `concurrencyPolicy: Forbid`) | Ejecución periódica finita con historial de corridas. |
| Salud | `readinessProbe` + `livenessProbe` | Postgres: `pg_isready`; Grafana: `GET /api/health`. |
| No agotar el anfitrión | `resources.requests/limits` | Postgres 1 CPU/1 Gi; Grafana 0,5 CPU/512 Mi; simulador 0,2 CPU/128 Mi; ETL 1 CPU/2 Gi. |
| Acceso desde el anfitrión | Services `ClusterIP` + `kubectl port-forward` a `127.0.0.1` | Coherente con la sección de seguridad: PostgreSQL nunca se expone públicamente. Power BI y DBeaver usan `localhost:5432`. |

## 4. Seguridad (sección J, parte de despliegue)
Rol `bi_lectura` (solo `SELECT` sobre `gold`, `bi`, `operativo`) para Grafana y Power BI; el ETL y el simulador usan `bi_user`. Grafana sin acceso anónimo ni registro de usuarios. Probado: una escritura con `bi_lectura` es rechazada (`permission denied`).

## 5. Grafana (sección H)
- Fuente PostgreSQL con `bi_lectura`, variable `inversor` (consulta a `gold.dim_inversor`).
- **Dashboard "Operativo en vivo"** (datos del simulador, refresco 10 s): SOC por inversor, minutos desde el último dato, energía importada de la red, energía por intervalo, SOC en el tiempo y estado actual.
- **Dashboard "Histórico (Gold)"**: usa las vistas del equipo (`bi.vw_grafana_energia`, `bi.vw_calidad_diaria`, `bi.vw_grafana_estado_actual`); rango por defecto 2026-06-01 a 2026-07-14.
- **Alertas** (las tres del informe + una de disponibilidad del pipeline; evaluación cada 1 min, sobre `operativo.*`):

| Regla | Condición | Umbral justificado |
|---|---|---|
| Alerta SOC crítico | SOC < 20 % durante 2 min | Evita descargas profundas; igual al `BATERIA_BAJA` de `bi.vw_grafana_estado_actual`. |
| Alerta de pérdida de telemetría | `SUM(n_validas)/SUM(n_lecturas)` < 95 % en ventana de 10 min | El informe pide < 95 % por hora; la demo acelerada usa 10 min reales (= 150 min físicos). |
| Alerta de fallo de inversor | ≥ 1 evento `grave` en `operativo.evento_inversor` (5 min), sin espera | Notificación inmediata. Declarar: el modelo Silver/Gold actual no trae eventos de falla, por eso la tabla es del simulador. |
| Sin datos nuevos | > 5 min sin lecturas | El simulador escribe cada minuto. |

### Matriz de verificación de paneles (con los nombres reales del modelo)
| Panel | Fuente PostgreSQL | Métrica / consulta | Dashboard |
|---|---|---|---|
| Potencia y energía FV vs. demanda de carga | `bi.vw_grafana_energia` / `operativo.lectura_stream` | `e_pv_kwh` vs `e_carga_kwh` | Histórico / En vivo |
| Estado de carga de baterías (SOC) | `bi.vw_grafana_energia` / `operativo.lectura_stream` | `soc_prom_pct` | Histórico / En vivo |
| Intercambio con la red pública | `bi.vw_grafana_energia` / `operativo.lectura_stream` | `e_red_kwh` | Histórico / En vivo |
| Disponibilidad de telemetría | `bi.vw_grafana_energia`, `bi.vw_calidad_diaria` | `n_validas / n_lecturas` (`datos_validos_pct`), `disponibilidad_intervalos_pct` | Ambos |

## 6. Simulador
Escribe en `operativo.lectura_stream` (no en Gold, para no contaminar Power BI) con las mismas unidades de `silver.lectura_15min`: energía (kWh) por intervalo de 15 min. **Cada fila es un intervalo sintético acelerado: 1 minuto real representa 15 min físicos** (declararlo en el informe). Escenarios en `bi-config`: `normal`, `nublado`, `falla_bateria`, `perdida_telemetria`, `falla_inversor`, `sin_datos`. Inserciones con `ON CONFLICT DO NOTHING` (idempotente).

## 7. Evidencia para el PDF
```
kubectl -n microrred-bi get all,pvc,configmap,secret
kubectl -n microrred-bi describe statefulset postgres
kubectl -n microrred-bi describe deployment grafana
kubectl -n microrred-bi get cronjob,jobs
kubectl -n microrred-bi logs job/etl-carga-historica
```
Capturas: ambos dashboards, pestaña *Alert rules* (Normal y Firing), DBeaver en `localhost:5432`.

## 8. Guion de demostración en vivo
1. Un comando: `./scripts/up.sh` (Windows: `.\scripts\up.ps1`). Borrar: `./scripts/down.sh`.
2. Abrir `http://localhost:3000` → *Operativo en vivo*.
3. Resiliencia de Postgres: `kubectl -n microrred-bi delete pod postgres-0` → vuelve y `SELECT count(*) FROM gold.fact_energia_intervalo;` no cambia.
4. Resiliencia de Grafana: `kubectl -n microrred-bi delete pod -l app=grafana` → vuelve con tableros y alertas sin tocar la interfaz.
5. Cambio sin reconstruir imagen: `kubectl -n microrred-bi patch configmap bi-config --type merge -p '{"data":{"SIM_ESCENARIO":"falla_bateria"}}'` → en ~4–6 min el SOC cae de 20 % y se dispara la alerta. Volver con `"normal"`.
6. `sin_datos` → a los 5 min se dispara la alerta de disponibilidad.
7. `perdida_telemetria` → el % de datos válidos baja a ~33 % y se dispara *pérdida de telemetría*. `falla_inversor` → inserta un evento grave y se dispara *fallo de inversor* de inmediato.
8. Bonus: `kubectl -n microrred-bi scale deployment grafana --replicas=2` funciona (stateless); PostgreSQL no se escala igual (cada réplica del StatefulSet sería una BD independiente con su PVC; haría falta replicación).
