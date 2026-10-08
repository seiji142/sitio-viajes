# CHANGELOG (plantilla del Núcleo)

Registro vivo de cambios mergeados + índice de lecciones (para que los
specs viejos no sean cementerio: lo promovible vive aquí, no solo en §8).

## Índice de lecciones

| Fecha | Lección | Etiqueta | Destino |
|-------|---------|----------|---------|
| 2026-10-07 | SRI calculado de los bytes reales del CDN (no de tablas): descargar + sha384 local | lección | docs/specs/base-extensible.md §3 |
| 2026-10-07 | `Join-Path` acepta 1 solo hijo posicional: anidar llamadas | error | docs/specs/base-extensible.md §8 |
| 2026-10-07 | Sin npm ni bundler con 1 sola dependencia: CDN pineado + SRI; re-evaluar con spec propia si hay mas | decisión | .ai/context.md |
| 2026-10-07 | `/adoptar-gitflow` se ejecuto desde otro proyecto por error: el registro vale solo donde se documenta (.ai/ + README + CHANGELOG de ESTE repo) | lección | .ai/context.md (Ramas) |
| 2026-10-07 | En `.bat`, `tasklist \| findstr` con 2 terminos rompe el parseo: preferir `taskkill /FI` sin pipes | error | docs/specs/base-extensible.md §8 |

## Entradas

### 2026-10-07 — Base extensible del sitio (spec `base-extensible.md` implementado)
Esqueleto: `src/index.html` (slots `data-effect`), `main.css` (tokens `:root` + mobile-first 768px),
`main.js` (loader 1-modulo-por-efecto) + `effects/none.js` inerte. GSAP 3.12.5 + ScrollTrigger
por CDN pineado con SRI verificado contra bytes reales. Sin npm/build/cambios CI.

### 2026-10-07 — Enmienda: lanzador local (spec `base-extensible.md` §§2,3,6,7)
`scripts/servir.ps1` (Python con fallback `npx serve`) + `scripts/servir.bat`
(doble clic). Verificado end-to-end: 200 en `/index.html`. Un fix de codigo
(`Join-Path` anidado), spec intacto.

### 2026-10-07 — Gitflow registrado en este proyecto (solo registro, sin publicar)
Ramas `main`/`develop` verificadas con tracking; `VERSION 2026.10.05.1` (=
scaffold, sin re-copies). Flujo documentado en `.ai/context.md` (Ramas) y
`.ai/commands.md` (Publicacion via `gh-publish.ps1`); `agents.md` con
worktree vigente. Pendiente manual del humano: proteccion de `main`
(PR sin approvals), `Pages` → `GitHub Actions`, `gh auth`.

### 2026-10-07 — Enmienda: modo background (spec `base-extensible.md`)
`scripts/iniciar.vbs` (sin ventana, PID en `scripts/.servir.pid`,
ignorado por git) + `scripts/detener.bat` (apaga por PID con `/T`,
respaldo por puerto). Verificado: 200 sin ventana visible, puerto
cerrado + `.pid` eliminado al detener. Un fix (`taskkill /FI`).
