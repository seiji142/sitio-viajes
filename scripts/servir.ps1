# Servidor estatico local para revision de sitio-viajes.
# Uso: doble clic a servir.bat, o: powershell -File scripts/servir.ps1
# Sirve src/ en http://localhost:8000 (Ctrl+C para detener).
$ErrorActionPreference = "Stop"
$port = 8000
$root = Join-Path (Join-Path $PSScriptRoot "..") "src"
if (-not (Test-Path -LiteralPath $root)) {
  Write-Output "ERROR: no existe la carpeta $root"
  exit 1
}
Write-Output "Sirviendo $root en http://localhost:$port (Ctrl+C para detener)"
try {
  $py = Get-Command python -ErrorAction Stop
  Write-Output "Python: $($py.Source)"
  python -m http.server $port --directory $root
} catch {
  Write-Output "Python no disponible, probando npx serve (requiere Node)..."
  npx serve $root -l $port
}
