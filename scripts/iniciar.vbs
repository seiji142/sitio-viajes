' Lanzador en background (sin ventana) para sitio-viajes.
' Uso: doble clic a iniciar.vbs. Detener con detener.bat.
' Lanza servir.ps1 oculto, guarda el PID en .servir.pid (ignorado por git).
Option Explicit
Dim fso, scriptDir, cmd, proc, pid, pidFile, f
Set fso = CreateObject("Scripting.FileSystemObject")
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
cmd = "powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & scriptDir & "\servir.ps1"""
Set proc = GetObject("winmgmts:").Get("Win32_Process")
If proc.Create(cmd, Null, Null, pid) <> 0 Then
  MsgBox "No se pudo iniciar el servidor.", 16, "sitio-viajes"
  WScript.Quit 1
End If
pidFile = scriptDir & "\.servir.pid"
Set f = fso.CreateTextFile(pidFile, True)
f.Write pid
f.Close
MsgBox "Servidor en http://localhost:8000 (PID " & pid & "). Para detenerlo usa detener.bat.", 64, "sitio-viajes"
