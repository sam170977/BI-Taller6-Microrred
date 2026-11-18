## J. Ética y seguridad

### J.1 Tratamiento de la tabla de contexto (Ley 1581 de 2012)

La tabla `context` (25,178 registros) almacena anotaciones operativas en formato JSON provenientes de siete fuentes (`source`): `workstation2_log` (8,902), `windows_event_log` (6,271), `workstation1_log` (6,028), `derived_context_pipeline` (3,708), `wsl_bash_history` (204), `manual entry` (60) y `manual_workload_entry` (5).

* **Análisis de datos personales:** Conforme a la Ley 1581 de 2012, constituye dato personal cualquier información vinculada o vinculable a una persona natural determinada o determinable. Al auditar las 60 claves JSON presentes en la fuente, se identificó que:
  * Los propios autores del dataset aplicaron controles previos de anonimización (incluyendo el campo `privacy_note` y comandos redactados en `example_commands_redacted` y `command_hints_redacted`), omitiendo nombres propios o correos electrónicos explícitos.
  * No obstante, persisten atributos indirectamente vinculables a la actividad de operadores o investigadores en las estaciones de trabajo (`workstation1`, `workstation2`), tales como `command` (11,974 registros), `directory` (11,974), `task_files` (11,974), `project` (209), `windows_event` (6,271), y coordenadas geográficas exactas del sitio (`latitude` y `longitude`, 996 registros).
* **Principios aplicados (art. 4 de la Ley 1581 de 2012):**
  * **Finalidad:** El contexto se emplea exclusivamente para correlacionar picos de carga eléctrica (compilación, entrenamiento de modelos GPU o eventos de sistema) con el balance energético y el ahorro en COP, nunca para perfilar o evaluar productividad individual.
  * **Minimización:** En el proceso ETL hacia las capas Silver y Gold se extraen únicamente los atributos analíticos necesarios (`context_type`, `task_type`, `device`, `inverter`, `cpu_cores_active`, `llm_estimated_task_effort`), descartando rutas locales (`directory`), comandos específicos (`command`), registros detallados de eventos de Windows y coordenadas geográficas precisas.
  * **Seguridad y confidencialidad:** La capa Bronze (`opencem.sqlite`) se mantiene aislada fuera del repositorio y de los contenedores de visualización. Las herramientas de BI (Power BI y Grafana) consultan exclusivamente la capa Gold mediante vistas y tablas agregadas sin metadatos de estación o usuario.
  * **Circulación restringida y atribución:** El dataset se utiliza bajo licencia abierta CC BY 4.0 con cita obligatoria a sus autores (Bartels et al., 2026); los tableros y capturas del informe exponen únicamente métricas energéticas y económicas agregadas.

### J.2 Seguridad de acceso y credenciales

* **Credenciales fuera del código y del repositorio:** Todas las contraseñas y cadenas de conexión se gestionan mediante variables de entorno locales (`.env`) y objetos `Secret` en Kubernetes, excluidos del control de versiones mediante `.gitignore`. En GitHub solo se versionan plantillas sin valores reales (`.env.example` y `k8s/secret.example.yaml`).
* **Alcance técnico de Secrets en Kubernetes:** Los `Secret` de Kubernetes codifican los valores en Base64 (no cifrado nativo), medida suficiente para el entorno académico local; en un despliegue productivo se integraría cifrado en reposo (ETCD encryption) o un gestor externo de secretos.
* **Principio de mínimo privilegio:** Se separa el usuario administrador utilizado por el proceso ETL de un rol de solo lectura (`SELECT`) en PostgreSQL, empleado por Power BI y Grafana para consultar el esquema `gold`, impidiendo modificaciones accidentales o inyección de cambios desde las capas de consumo.
* **Endurecimiento de Grafana y exposición de red:** Grafana se despliega con credenciales administrativas personalizadas y acceso anónimo deshabilitado. PostgreSQL opera como servicio interno (`ClusterIP`) sin exposición pública; el acceso desde DBeaver y Power BI en el equipo anfitrión se realiza de forma controlada mediante `kubectl port-forward` o puerto mapeado localmente.
* **Integridad de contenedores:** Todas las imágenes base y de servicios utilizan etiquetas de versión fija (sin `latest`) y no incorporan secretos ni datos crudos dentro de sus capas.