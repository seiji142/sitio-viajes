# `scripts/` — Tooling

- `ci_checks.py`: CI de artefactos del Nucleo (stdlib, sin dependencias):
  valida `opencode.json`, frontmatter de skills, indice `docs/README.md`
  y specs. Corre en CI (`artefactos`) y en local con
  `python scripts/ci_checks.py`.
- `servir.ps1` + `servir.bat`: servidor estatico local (doble clic al
  `.bat`): sirve `src/` en `http://localhost:8000`. Requiere Python
  (fallback: `npx serve`). Solo desarrollo local, no va a CI.
- `iniciar.vbs` + `detener.bat`: mismo servidor en background SIN ventana
  (doble clic a cada uno). `iniciar.vbs` guarda el PID en
  `scripts/.servir.pid` (ignorado por git); `detener.bat` apaga por PID
  (respaldo: busca por puerto 8000) y confirma el puerto libre.
