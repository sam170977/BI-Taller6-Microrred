Set-Location (Join-Path $PSScriptRoot "..")
$e = @{}; Get-Content k8s/.env | Where-Object { $_ -match '^\s*[^#].*=' } | ForEach-Object { $k,$v = $_ -split '=',2; $e[$k.Trim()] = $v.Trim() }
foreach ($f in "sql/07_datos_demo_sinteticos.sql","sql/03_carga_gold.sql") {
  Get-Content $f -Raw | kubectl -n microrred-bi exec -i postgres-0 -- psql -v ON_ERROR_STOP=1 -U $e.POSTGRES_USER -d $e.POSTGRES_DB
}
