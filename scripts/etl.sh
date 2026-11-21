#!/usr/bin/env bash
# Carga historica (Job). Requiere data/<archivo>.sqlite descomprimido y SQLITE_PATH correcto en k8s/configmap.yaml
set -euo pipefail
cd "$(dirname "$0")/.."
kubectl -n microrred-bi delete job etl-carga-historica --ignore-not-found
kubectl apply -f k8s/jobs/etl-job.yaml
kubectl -n microrred-bi wait --for=condition=complete job/etl-carga-historica --timeout=1800s
kubectl -n microrred-bi logs job/etl-carga-historica | tail -40
