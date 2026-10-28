# Comandos Personalizados

## Herramientas MCP (se invocan por nombre en el chat)

No son comandos slash: son tools del servidor MCP `youtube-transcripts`,
registradas como `<server_name>_<tool_name>`. Se escriben en el chat del modelo.

### YouTube

| Tool | Descripción |
|------|-------------|
| `youtube_transcript` | Extraer transcripción de un video (puede devolver `processing` + `job_id`) |
| `youtube_transcript_status` | Consultar el estado de un job ASR |
| `youtube_transcript_read` | Leer un tramo por segundos (verificar fragmentos dudosos) |
| `youtube_transcript_search` | Búsqueda BM25 con citas `&t=` |
| `youtube_transcript_summary` | Resumen por secciones + overall con citas `&t=` |
| `youtube_health` | Diagnóstico del servidor (proveedores, breakers, métricas) |

> En este proyecto no hay servidor MCP de memoria: no existen aqui
> tools `brain-ai_*`. La memoria es conceptual (ver `.ai/MEMORY.md`).

## Comandos slash custom

Este proyecto **no define comandos slash**. Crear uno requiere un archivo en
`.opencode/commands/<nombre>.md` o una sección `command` en `opencode.json`; ninguno
de los dos existe. Los built-in de OpenCode son `/init`, `/undo`, `/redo`, `/share`, `/help`.

## Clasificacion del cambio: SDD u ODD

Todo cambio autorizado se clasifica ANTES de escribir codigo. O lleva spec
(`docs/specs/<tema>.md`) o va en modo ODD. No hay tercera via.

### Prueba de reanudacion (decide; el tamano no)

Modo ODD solo si se cumplen las tres:
1. **Entendido**: no queda ninguna decision de producto abierta.
2. **Riesgo contenido**: no toca ningun escalador duro.
3. **Reanudable**: enumera las decisiones abiertas. Si alguna no se resuelve
   con el pedido o con `git diff` (incluida cualquier convencion que tengas
   que suponer), entonces no es ODD.

Falla cualquiera -> modo SDD (spec completo, y FICHA si hay entregable).

El conteo de archivos, lineas, tests o tareas NUNCA decide: un cambio de
una linea en auth es SDD; uno de 20 en un README puede ser ODD.

### Escaladores duros (siempre SDD)

Seguridad/auth, datos o migraciones, contratos de API que otros consumen,
dependencias nuevas, CI/workflows, crypto, permisos de `opencode.json`,
reglas y roles (`.ai/system.md`, `.ai/rules.md`, `.ai/commands.md`,
`.ai/agents.md`) o skills (`.agents/skills/`), operaciones irreversibles,
y `scripts/`.

### Que entrega cada modo

| | SDD | ODD |
|---|---|---|
| Documento | spec + FICHA | ninguno |
| Evidencia | §6, §7 y §8 del spec | commit + resultado observado en el chat |
| Verificacion pre-PR | obligatoria | obligatoria (identica) |
| Auditoria, si el proyecto la define | segun sus disparadores | segun sus disparadores |

En ODD la evidencia vive en el commit: asunto en imperativo y en el cuerpo
`ODD: <por que> / <que se observo>`. Sin esa linea no es ODD: es un cambio
sin evidencia.

### Prohibido

- Usar ODD para saltarse el criterio de aceptacion explicito del usuario.
- Declarar ODD despues de implementar para justificar la falta de spec.
- Partir un cambio SDD en varios ODD para esquivar el spec.

## Validacion pre-PR (obligatoria, bloqueante)

NINGUN PR se abre sin completar la checklist, sin excepciones
por "cambio chico". Este es codigo visual (sitio estatico HTML/CSS/JS).

### Checklist — sitio estatico

1. [ ] Pagina(s) verificada(s) en local: abrir `src/index.html` en el
   navegador (o `npx serve src`) sin errores en consola.
2. [ ] Links e imagenes: sin rotos (rutas relativas `assets/...`).
3. [ ] Responsive: comprobar movil (360px) + escritorio (1280px).
4. [ ] Accesibilidad minima: `lang="es"`, `alt` en imagenes, contraste legible.
5. [ ] Si el cambio usa un video: afirmaciones con cita `&t=` y tramos
   dudosos verificados con `youtube_transcript_read`.
6. [ ] Criterio de aceptacion EXPLICITO del usuario en el chat.
   Sin ese mensaje, NO hay PR.
   Cuenta: una frase sobre el CAMBIO ("el endpoint devuelve 200", "el
   typo ya no esta", "el kit quedo integrado").
   No cuenta: la orden de publicar ("abre el PR", "mergea", "subilo"):
   autoriza la accion, no acepta el resultado.

### Cierre

7. [ ] Tras cada fix: repetir pruebas afectadas + auditoría si toca sus
   disparadores (ver `.ai/agents.md` rol 3). Un fix sin re-verificación
   no existe.
8. [ ] CI en verde en el PR (obligatorio; `python scripts/ci_checks.py`
   en local antes de subir).

Regla: el riesgo percibido NUNCA saltea pasos. Lo que no tiene evidencia
(chequeo local + CI verde) se considera NO verificado.

## Publicacion (PRs y merges)

OBLIGATORIO: NUNCA uses `gh pr create` / `gh pr merge` directos.
Todo PR y merge pasa por `scripts/gh-publish.ps1` (ejecutar desde la raiz del repo).

| Tarea | Comando |
|-------|---------|
| PR + merge `feature/x` -> `develop` | `.\scripts\gh-publish.ps1 -Rama feature/x -Base develop -Merge` |
| PR + merge `develop` -> `main` (publicar, dispara Pages) | `.\scripts\gh-publish.ps1 -Merge` |
| Solo crear PR (sin mergear) | Mismo comando sin `-Merge` |

Pre-publicar a `main`: OK visual EXPLICITO del usuario en el chat + Pages
activado (`Settings` → `Pages` → `Source: GitHub Actions`). Sin ese mensaje,
NO hay PR a `main`.
Cuenta: una frase sobre el CAMBIO ("se ve bien en movil y escritorio").
No cuenta: la orden de publicar ("publica", "mergea", "subilo a main"):
autoriza la accion, no acepta el resultado.
