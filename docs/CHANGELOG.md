# CHANGELOG (plantilla del Núcleo)

Registro vivo de cambios mergeados + índice de lecciones (para que los
specs viejos no sean cementerio: lo promovible vive aquí, no solo en §8).

## Índice de lecciones

| Fecha | Lección | Etiqueta | Destino |
|-------|---------|----------|---------|
| 2026-10-07 | SRI calculado de los bytes reales del CDN (no de tablas): descargar + sha384 local | lección | docs/specs/base-extensible.md §3 |
| 2026-10-07 | `Join-Path` acepta 1 solo hijo posicional: anidar llamadas | error | docs/specs/base-extensible.md §8 |
| 2026-10-07 | Sin npm ni bundler con 1 sola dependencia: CDN pineado + SRI; re-evaluar con spec propia si hay mas | decisión | .ai/context.md |

## Entradas

### 2026-10-07 — Base extensible del sitio (spec `base-extensible.md` implementado)
Esqueleto: `src/index.html` (slots `data-effect`), `main.css` (tokens `:root` + mobile-first 768px),
`main.js` (loader 1-modulo-por-efecto) + `effects/none.js` inerte. GSAP 3.12.5 + ScrollTrigger
por CDN pineado con SRI verificado contra bytes reales. Sin npm/build/cambios CI.

### 2026-10-07 — Enmienda: lanzador local (spec `base-extensible.md` §§2,3,6,7)
`scripts/servir.ps1` (Python con fallback `npx serve`) + `scripts/servir.bat`
(doble clic). Verificado end-to-end: 200 en `/index.html`. Un fix de codigo
(`Join-Path` anidado), spec intacto.
