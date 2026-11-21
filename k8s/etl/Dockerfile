# Construir DESDE LA RAIZ del repo:  docker build -f k8s/etl/Dockerfile -t microrred/etl:1.0.0 .   (usa etl/etl_bronze_silver.py sin modificarlo)
# python:3.12-slim-bookworm: sqlite3 viene en la libreria estandar; solo se agrega psycopg[binary].
# El .sqlite (Bronze) NO va en la imagen: se monta en solo lectura en /data.
FROM python:3.12-slim-bookworm
ENV PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1
WORKDIR /app
COPY k8s/etl/requirements.txt .
RUN pip install -r requirements.txt
COPY etl/etl_bronze_silver.py k8s/etl/aplicar_sql.py ./
COPY sql/03_carga_gold.sql ./sql/03_carga_gold.sql
RUN useradd -r -u 10001 etl
USER 10001
CMD ["sh", "-c", "python etl_bronze_silver.py && python aplicar_sql.py sql/03_carga_gold.sql"]
