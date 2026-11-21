#!/usr/bin/env bash
# Levanta TODO desde cero con un solo comando (requiere Docker, kind, kubectl).
set -euo pipefail
cd "$(dirname "$0")/.."
if [ ! -f k8s/.env ]; then
  # Primera vez (p. ej. el docente que clona el repo): crea k8s/.env con claves aleatorias. No se sube a git.
  clave() { LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16 || true; }
  sed -e "s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=$(clave)|" \
      -e "s|^GF_SECURITY_ADMIN_PASSWORD=.*|GF_SECURITY_ADMIN_PASSWORD=$(clave)|" \
      -e "s|^BI_LECTURA_PASSWORD=.*|BI_LECTURA_PASSWORD=$(clave)|" \
      k8s/.env.example > k8s/.env
  echo "Se creo k8s/.env con claves aleatorias (abralo para verlas)."
fi
set -a; . ./k8s/.env; set +a
mkdir -p data

if ! kind get clusters | grep -qx microrred; then
  KC=$(mktemp); sed "s|__DATA_DIR__|$(pwd)/data|" k8s/kind/kind-config.tpl.yaml > "$KC"
  kind create cluster --config "$KC"
fi
docker build -f simulador/Dockerfile -t microrred/simulador:1.0.0 .
docker build -f k8s/etl/Dockerfile       -t microrred/etl:1.0.0 .
kind load docker-image microrred/simulador:1.0.0 microrred/etl:1.0.0 --name microrred

kubectl apply -f k8s/namespace.yaml
kubectl -n microrred-bi create secret generic bi-credentials \
  --from-literal=POSTGRES_USER="$POSTGRES_USER" --from-literal=POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
  --from-literal=POSTGRES_DB="$POSTGRES_DB" --from-literal=BI_LECTURA_PASSWORD="$BI_LECTURA_PASSWORD" \
  --from-literal=GF_SECURITY_ADMIN_PASSWORD="$GF_SECURITY_ADMIN_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -k .
kubectl -n microrred-bi rollout status statefulset/postgres --timeout=240s
kubectl -n microrred-bi rollout status deployment/grafana --timeout=240s
./scripts/port-forward.sh
echo "Grafana: http://localhost:3000 (admin / GF_SECURITY_ADMIN_PASSWORD) | PostgreSQL: localhost:5432"
