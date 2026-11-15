# Taller 6 – BI contenerizado para una microrred híbrida

Solución de Inteligencia de Negocios de extremo a extremo sobre la telemetría de una microrred híbrida (solar + batería + red): ETL reproducible con validación de calidad, modelo dimensional en PostgreSQL, tablero analítico en Power BI y tablero operativo en Grafana con alertas, desplegado sobre un clúster local de Kubernetes.

**Enfoque de profundización (Línea 3):** SolarBI: estimación del ahorro económico de la generación solar con la tarifa colombiana.

**Curso:** Inteligencia de Negocios 2026-II · Institución Universitaria Pascual Bravo · Docente: Ramiro Grisales Montoya

## Integrantes
| Integrante | Responsabilidad principal |
|---|---|
| Sammy Arteaga Velasquez  | Repositorio, Power BI, ética y seguridad, ensamblado del informe |
| Shirley Johanna Grajales Arango | Datos, diagnóstico de calidad, ETL |
| Yuritza Mendoza Mosquera | Catálogo de indicadores, modelo dimensional, PostgreSQL |
| Laura Mejia Delgado | Docker, Kubernetes, Grafana, simulador |

## Datos y licencia
Datos: OpenCEM v1.0.0 (Zenodo, DOI 10.5281/zenodo.21436223), licencia CC BY 4.0.
Los datos **no** están en este repositorio. Descarga y verificación: ver [`data/README.md`](data/README.md).

**Cita:** Bartels, T. S., Wu, R., Lu, X., Chen, Y., Lu, Y., Xia, F., Yang, H., Chen, Y., & Li, T. (2026). *OpenCEM: Multimodal photovoltaic and battery microgrid dataset with context records and sky imagery* (Version 1.0.0) [Dataset]. Zenodo. https://doi.org/10.5281/zenodo.21436223

## Estructura del repositorio
```
├── etl/          Código y Dockerfile del ETL (Bronze → Silver → Gold)
├── simulador/    Simulador de datos nuevos y su Dockerfile
├── sql/          DDL, consultas analíticas y consulta con JSON
├── k8s/          Manifiestos de Kubernetes
├── grafana/      Dashboard exportado y provisioning
├── powerbi/      Proyecto Power BI en formato .pbip
├── docs/         Diagramas, diccionario de datos, capturas
└── data/         Vacía; ver data/README.md
```

## Arquitectura
_(pendiente: diagrama y descripción de componentes)_

## Requisitos del equipo anfitrión
_(pendiente: Docker, kubectl, distribución de Kubernetes, DBeaver, Power BI Desktop)_

## Cómo reproducir desde cero
_(pendiente: un comando para levantar y otro para eliminar el despliegue)_

## Ética y seguridad
Análisis completo en [`docs/etica-seguridad.md`](docs/etica-seguridad.md). Resumen:

- **Datos personales (Ley 1581 de 2012):** la tabla de contexto se usa solo para explicar el comportamiento energético, nunca para evaluar o vigilar personas. El ETL aplica minimización: los campos que identifican personas se pseudonimizan o se descartan antes de la capa Gold, y los tableros consumen solo esa capa.
- **Credenciales:** fuera del código y del repositorio (`.env` y `Secret` de Kubernetes excluidos con `.gitignore`; solo se versionan plantillas `.env.example`).
- **Mínimo privilegio:** Power BI y Grafana consultan con un usuario de solo lectura de PostgreSQL.
- **Exposición de red:** PostgreSQL solo es accesible dentro del clúster; el acceso desde el anfitrión es por `port-forward` local.

## Flujo de trabajo
Cada integrante trabaja en su propia rama (`feature/etl`, `feature/modelo`, `feature/k8s`, `feature/powerbi`) con commits pequeños y frecuentes, y se integra a `main` mediante pull request.
