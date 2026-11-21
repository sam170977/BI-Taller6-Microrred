# Windows PowerShell: levanta todo con un comando (requiere Docker Desktop, kind, kubectl)
$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")
if (-not (Test-Path k8s/.env)) {
  # Primera vez (p. ej. el docente que clona el repo): crea k8s/.env con claves aleatorias. No se sube a git.
  function New-Clave { -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 16 | ForEach-Object { [char]$_ }) }
  Get-Content k8s/.env.example | ForEach-Object {
    if     ($_ -match '^POSTGRES_PASSWORD=')           { "POSTGRES_PASSWORD=$(New-Clave)" }
    elseif ($_ -match '^GF_SECURITY_ADMIN_PASSWORD=')  { "GF_SECURITY_ADMIN_PASSWORD=$(New-Clave)" }
    elseif ($_ -match '^BI_LECTURA_PASSWORD=')         { "BI_LECTURA_PASSWORD=$(New-Clave)" }
    else { $_ }
  } | Set-Content k8s/.env
  Write-Host "Se creo k8s/.env con claves aleatorias (abralo para verlas: notepad k8s\.env)"
}
$e = @{}; Get-Content k8s/.env | Where-Object { $_ -match '^\s*[^#].*=' } | ForEach-Object { $k,$v = $_ -split '=',2; $e[$k.Trim()] = $v.Trim() }
New-Item -ItemType Directory -Force data | Out-Null
if (-not ((kind get clusters) -contains "microrred")) {
  $kc = Join-Path $env:TEMP "kind-microrred.yaml"
  $dataDir = (Resolve-Path data).Path -replace '\\','/'
  (Get-Content k8s/kind/kind-config.tpl.yaml) -replace '__DATA_DIR__', $dataDir | Set-Content $kc
  kind create cluster --config $kc
}
docker build -f simulador/Dockerfile -t microrred/simulador:1.0.0 .
docker build -f k8s/etl/Dockerfile       -t microrred/etl:1.0.0 .
kind load docker-image microrred/simulador:1.0.0 microrred/etl:1.0.0 --name microrred
kubectl apply -f k8s/namespace.yaml
kubectl -n microrred-bi create secret generic bi-credentials `
  --from-literal=POSTGRES_USER=$($e.POSTGRES_USER) --from-literal=POSTGRES_PASSWORD=$($e.POSTGRES_PASSWORD) `
  --from-literal=POSTGRES_DB=$($e.POSTGRES_DB) --from-literal=BI_LECTURA_PASSWORD=$($e.BI_LECTURA_PASSWORD) `
  --from-literal=GF_SECURITY_ADMIN_PASSWORD=$($e.GF_SECURITY_ADMIN_PASSWORD) --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -k .
kubectl -n microrred-bi rollout status statefulset/postgres --timeout=240s
kubectl -n microrred-bi rollout status deployment/grafana --timeout=240s
& "$PSScriptRoot/port-forward.ps1"
Write-Host "Grafana: http://localhost:3000  |  PostgreSQL: localhost:5432"
