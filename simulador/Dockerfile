# python:3.12-slim-bookworm: base pequena (~45 MB comprimida) con Python; psycopg[binary] evita compiladores.
# Se descarto Alpine (musl) por friccion con wheels binarios. Usuario no-root; sin secretos en la imagen.
FROM python:3.12-slim-bookworm
ENV PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1
WORKDIR /app
COPY simulador/requirements.txt .
RUN pip install -r requirements.txt
COPY simulador/simulador.py .
RUN useradd -r -u 10001 sim
USER 10001
CMD ["python", "simulador.py"]
