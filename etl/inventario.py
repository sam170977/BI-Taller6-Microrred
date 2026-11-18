#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Inventario de la capa Bronze (base SQLite de OpenCEM).

Para cada tabla: número de filas, columnas con su tipo, porcentaje de valores nulos,
muestra de 3 filas y el rango de las columnas que parecen de tiempo.
El archivo se abre en SOLO LECTURA (mode=ro): este script no puede modificar Bronze.

Uso:
    python etl/inventario.py data/opencem-v1.0.0.sqlite
    python etl/inventario.py data/opencem-v1.0.0.sqlite --sin-nulos     # más rápido
Salida: pantalla y docs/inventario_bronze.md (evidencia para el informe).
"""
import argparse
import sqlite3
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

PISTAS_TIEMPO = ("time", "date", "fecha", "stamp", "start", "end", "valid", "created", "entered", "_ts", "ts_")


def conectar_solo_lectura(ruta):
    p = Path(ruta).resolve()
    if not p.exists():
        sys.exit(f"No existe el archivo: {p}")
    return sqlite3.connect(f"{p.as_uri()}?mode=ro", uri=True)


def legible(v):
    """Si un número parece una época Unix (s o ms), lo muestra como fecha UTC; si no, lo deja igual."""
    if isinstance(v, (int, float)):
        for escala, nombre in ((1, "s"), (1000, "ms")):
            x = v / escala
            if 946684800 <= x <= 4102444800:       # 2000-01-01 a 2100-01-01
                return f"{v} ({datetime.fromtimestamp(x, timezone.utc):%Y-%m-%d %H:%M:%S} UTC, época en {nombre})"
    return str(v)


def es_tiempo(nombre, tipo):
    n = nombre.lower()
    return any(p in n for p in PISTAS_TIEMPO) or "date" in (tipo or "").lower() or "time" in (tipo or "").lower()


def main():
    ap = argparse.ArgumentParser(description="Inventario de la base SQLite de OpenCEM")
    ap.add_argument("sqlite")
    ap.add_argument("--sin-nulos", action="store_true", help="omitir el conteo de nulos (más rápido)")
    ap.add_argument("--salida", default="docs/inventario_bronze.md")
    args = ap.parse_args()

    con = conectar_solo_lectura(args.sqlite)
    cur = con.cursor()
    cur.execute("SELECT name, type FROM sqlite_master WHERE type IN ('table','view') AND name NOT LIKE 'sqlite_%' ORDER BY name")
    objetos = cur.fetchall()

    md = [f"# Inventario de Bronze\n", f"Archivo: `{Path(args.sqlite).name}`  \nGenerado: {datetime.now():%Y-%m-%d %H:%M}\n",
          "| Objeto | Tipo | Filas | Columnas |", "|---|---|---:|---:|"]
    detalle = []

    for nombre, tipo_obj in objetos:
        t0 = time.time()
        cur.execute(f'PRAGMA table_info("{nombre}")')
        cols = [(c[1], c[2]) for c in cur.fetchall()]
        cur.execute(f'SELECT COUNT(*) FROM "{nombre}"')
        n = cur.fetchone()[0]
        print(f"[{nombre}] {n:,} filas, {len(cols)} columnas ...", flush=True)

        nulos = {}
        if not args.sin_nulos and n:
            expr = ", ".join(f'COUNT("{c}")' for c, _ in cols)
            cur.execute(f'SELECT {expr} FROM "{nombre}"')
            for (c, _), no_nulos in zip(cols, cur.fetchone()):
                nulos[c] = 100.0 * (n - no_nulos) / n

        rangos = {}
        for c, t in cols:
            if n and es_tiempo(c, t):
                cur.execute(f'SELECT MIN("{c}"), MAX("{c}") FROM "{nombre}"')
                rangos[c] = cur.fetchone()

        cur.execute(f'SELECT * FROM "{nombre}" LIMIT 3')
        muestra = cur.fetchall()

        md.append(f"| {nombre} | {tipo_obj} | {n:,} | {len(cols)} |")
        d = [f"\n## {nombre}\n", f"Filas: **{n:,}** · Columnas: **{len(cols)}**\n"]
        if rangos:
            d.append("Rango de columnas de tiempo:\n")
            for c, (a, b) in rangos.items():
                d.append(f"- `{c}`: de {legible(a)} a {legible(b)}")
            d.append("")
        d.append("| Columna | Tipo | % nulos |" if nulos else "| Columna | Tipo |")
        d.append("|---|---|---:|" if nulos else "|---|---|")
        for c, t in cols:
            d.append(f"| {c} | {t or '(sin tipo)'} | {nulos[c]:.1f} |" if nulos else f"| {c} | {t or '(sin tipo)'} |")
        d.append("\nMuestra (3 filas):\n")
        for fila in muestra:
            d.append("- " + ", ".join(f"{c}={str(v)[:60]}" for (c, _), v in zip(cols, fila)))
        detalle.extend(d)
        print(f"    listo en {time.time() - t0:.1f} s", flush=True)

    texto = "\n".join(md + detalle) + "\n"
    Path(args.salida).parent.mkdir(parents=True, exist_ok=True)
    Path(args.salida).write_text(texto, encoding="utf-8")
    print(f"\nInventario guardado en {args.salida}")
    con.close()


if __name__ == "__main__":
    main()
