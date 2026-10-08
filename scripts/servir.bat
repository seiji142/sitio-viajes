@echo off
rem Lanzador con doble clic: sirve src/ en http://localhost:8000
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0servir.ps1"
pause
