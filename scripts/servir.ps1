# Servidor estatico local para revision de sitio-viajes.
# Uso: doble clic a servir.bat, o: powershell -File scripts/servir.ps1
# Sirve src/ en http://localhost:8000 (Ctrl+C para detener).
$ErrorActionPreference = "Stop"
$port = 8000
$root = Join-Path (Join-Path $PSScriptRoot "..") "src"
Write-Output "Sirviendo $root en http://localhost:$port (Ctrl+C para detener)"
if (Get-Command python -ErrorAction SilentlyContinue) {
  python -m http.server $port --directory $root
} else {
  npx serve $root -l $port
}
