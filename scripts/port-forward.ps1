Get-Process kubectl -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*port-forward*" } | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Process kubectl -WindowStyle Hidden -ArgumentList "-n microrred-bi port-forward svc/postgres 5432:5432"
Start-Process kubectl -WindowStyle Hidden -ArgumentList "-n microrred-bi port-forward svc/grafana 3000:3000"
