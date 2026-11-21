#!/usr/bin/env bash
# Acceso desde el anfitrion (Power BI, DBeaver, navegador). Solo escucha en 127.0.0.1.
pkill -f "port-forward.*microrred-bi" 2>/dev/null || true
kubectl -n microrred-bi port-forward svc/postgres 5432:5432 >/dev/null 2>&1 &
kubectl -n microrred-bi port-forward svc/grafana  3000:3000 >/dev/null 2>&1 &
sleep 2
