# J. Ética y seguridad

## J.1 Tratamiento de la tabla de contexto (Ley 1581 de 2012)

La tabla de contexto contiene anotaciones en JSON que dejan las estaciones de trabajo y el personal del sitio (qué tarea se lanzó, cuándo se encendió el aire). Aunque el objetivo del taller es energético, estas anotaciones pueden relacionarse con personas.

**Análisis de datos personales.** La Ley 1581 de 2012 define como dato personal cualquier información vinculada o vinculable a una persona natural determinada o determinable. Revisamos los campos del JSON y encontramos: **[COMPLETAR: lista de campos, por ejemplo identificadores de usuario, nombres de estación, nombres de tarea o correos; indicar cuáles identifican o podrían identificar a una persona y cuáles no]**.

**Principios aplicados** (art. 4 de la ley):

- **Finalidad:** usamos el contexto solo para explicar el comportamiento energético (por ejemplo, el consumo de una carga de GPU), no para evaluar o vigilar a las personas.
- **Minimización:** en el ETL cargamos únicamente los campos que necesita el modelo. Los campos que identifican personas se pseudonimizan (hash con sal) o se descartan antes de llegar a la capa Gold.
- **Seguridad y confidencialidad:** la capa Bronze se conserva sin modificar y con acceso restringido. Los tableros consumen solo la capa Gold, sin identificadores personales.
- **Circulación restringida:** los tableros públicos y las capturas del informe no muestran datos identificables.
- **Origen del dato:** OpenCEM se publica bajo CC BY 4.0 y citamos a sus autores. La licencia abierta no elimina la obligación de tratar con cuidado cualquier dato personal que contenga.

**Limitación:** no somos el responsable original del tratamiento de esos datos, y la ley exige autorización del titular para tratamientos con fines distintos al original. Por eso aplicamos minimización y no intentamos reidentificar a nadie.

## J.2 Seguridad de acceso y credenciales

- **Credenciales fuera del código:** las contraseñas viven en un `Secret` de Kubernetes y en un archivo `.env` local, ambos excluidos con `.gitignore`. En el repositorio solo hay plantillas (`.env.example`, `secret.example.yaml`).
- **Aclaración técnica:** un `Secret` guarda los valores en base64, que no es cifrado. En el clúster local se acepta como nivel básico; en producción se usaría cifrado en reposo o un gestor de secretos.
- **Mínimo privilegio:** además del usuario administrador, se crea un usuario de solo lectura de PostgreSQL, que usan Power BI y Grafana para consultar la capa Gold. Ninguno de los dos puede modificar datos. **[CONFIRMAR con quien implemente PostgreSQL]**
- **Grafana:** contraseña de administrador distinta de la predeterminada, acceso anónimo deshabilitado y fuente de datos aprovisionada con el usuario de solo lectura. **[CONFIRMAR con quien implemente Grafana]**
- **Exposición de red:** PostgreSQL queda como servicio interno del clúster (`ClusterIP`). Solo Grafana se expone al anfitrión, y el acceso a la base desde DBeaver o Power BI se hace por `port-forward` local. **[CONFIRMAR con quien implemente Kubernetes]**
- **Imágenes:** versiones fijas (sin `latest`) y ninguna credencial dentro de las imágenes.
- **Si una credencial se sube por error:** se considera comprometida, se cambia de inmediato y se retira del historial de Git.

> Nota: esta sección es un análisis académico, no asesoría legal.
