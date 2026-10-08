@echo off
setlocal
rem Detiene el servidor lanzado con iniciar.vbs (o servir.bat).
set PIDFILE=%~dp0.servir.pid
if not exist "%PIDFILE%" goto :bypid
set /p PID=<"%PIDFILE%"
taskkill /FI "PID eq %PID%" /FI "IMAGENAME eq powershell.exe" /T /F >nul 2>&1
taskkill /FI "PID eq %PID%" /FI "IMAGENAME eq python.exe" /F >nul 2>&1
del "%PIDFILE%"
echo Orden de detener enviada al PID %PID%.
goto :check
:bypid
echo No hay .servir.pid; buscando procesos en puerto 8000...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8000" ^| findstr "LISTENING"') do (
  taskkill /PID %%a /F >nul 2>&1
  echo Proceso %%a detenido.
)
:check
set BUSY=
for /f "tokens=5" %%b in ('netstat -ano ^| findstr ":8000" ^| findstr "LISTENING"') do set BUSY=1
if defined BUSY (
  echo AVISO: el puerto 8000 sigue ocupado.
) else (
  echo Puerto 8000 libre.
)
