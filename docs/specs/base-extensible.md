---
titulo: Base extensible del sitio (layout + CSS vars + slots data-effect)
estado: implementado  # borrador | aprobado | implementado (enmienda lanzador verificada 2026-10-07)
entradas:
  - docs/specs/PLANTILLA.md
  - Convenciones de .ai/context.md (sitio estatico, sin build)
  - Decision: GSAP por CDN pineado con SRI (sin npm ni bundler)
salidas:
  - Esqueleto extensible verificado: layout + tokens + slots + loader + 1 modulo de ejemplo inerte
dependencias:
  - src/index.html, src/assets/css/main.css, src/assets/js/main.js
  - CDN externo gsap@3.12.5 + ScrollTrigger (pineado + SRI)
tablas_impactadas: []
criterio_aceptacion: El esqueleto carga sin errores con GSAP por CDN, cada seccion expone su slot data-effect, scripts/servir.* levanta el servidor local en 200, y el CI sigue verde (job artefactos, sin cambios).
---

# Base extensible del sitio

## 1. Problema
Cada efecto visual futuro obligaria a reestructurar layout, CSS y carga de
scripts si no hay una base comun. El humano construye el sitio por features
(un efecto por feature) y necesita un esqueleto donde cada efecto encaje sin
reescribir lo existente.

## 2. Alcance
- Incluye:
  - Layout base `src/index.html` con slots `data-effect` por seccion
  - CSS vars centralizadas (`:root` en `main.css`: colores, espaciado, breakpoint 768px)
  - Convencion 1 modulo JS por efecto (`src/assets/js/effects/<nombre>.js`) + loader en `main.js`
  - Carga de GSAP + ScrollTrigger por CDN pineado con SRI
  - 1 modulo de ejemplo inerte (registra el slot sin animar: prueba la convencion)
  - Lanzador local `scripts/servir.ps1` + `scripts/servir.bat` (doble clic: sirve `src/` en puerto 8000)
- Excluye (explícito):
  - Efectos concretos (se definen despues, uno por feature)
  - Contenido final de la home y paginas de destino
  - `package.json` / bundler / cambios en CI (se re-evalua con su propia spec si hacen falta mas dependencias)

## 3. Módulos / piezas
- `src/index.html`: secciones con `data-effect="<nombre>"`; `<script>` CDN gsap@3.12.5 + ScrollTrigger con `integrity` + `crossorigin`; `main.js` propio al final
- `src/assets/css/main.css`: `:root` con tokens + layout mobile-first
- `src/assets/js/main.js`: loader — escanea `[data-effect]`, importa el modulo correspondiente, lo inicializa; slots sin modulo registrado se ignoran sin error
- `src/assets/js/effects/none.js` (ejemplo inerte): registra el slot sin animar
- `scripts/servir.ps1`: sirve `src/` en `http://localhost:8000` (Python; fallback `npx serve`); `scripts/servir.bat` lo invoca con doble clic

## 4. Stack y dependencias
HTML5/CSS3/JS vanilla + GSAP 3.12.5 + ScrollTrigger via CDN (sin npm, sin
build, sin backend). CI sin cambios (`artefactos`).

## 5. Diseño
- Slots `data-effect` desacoplan contenido de efectos: añadir un efecto = nuevo modulo + atributo, sin tocar el loader. (Descartada: JS monolitico — crece acoplado y sin control.)
- CSS vars en `:root` de `main.css`, sin nuevo archivo de tokens. (Descartada: `tokens.css` separado — sobra para el tamaño actual; se re-evalua si los tokens crecen.)
- GSAP por CDN pineado + SRI en vez de npm/bundler. (Descartada: npm + importmap/bundler — innecesario con una sola dependencia; se re-evalua con spec propia si hay mas.)

## 6. Plan de verificación
- Qué ejecuta `fx-test`: abrir `src/index.html` en navegador (via servidor estatico local, no `file://` por los modulos ES) sin errores en consola; `window.gsap` definido; cada `[data-effect]` resuelto o ignorado sin error; lanzador `servir.bat` responde 200 en `http://localhost:8000/index.html`; `python scripts/ci_checks.py` verde.
- Qué revisa `my-review`: sin duplicados, sin secretos, SRI presente en los `<script>` CDN, degradacion sin red (la pagina es legible aunque el CDN falle).

## 7. Criterio de aceptación
El esqueleto carga sin errores con GSAP por CDN, cada seccion expone su slot data-effect, scripts/servir.* levanta el servidor local en 200, y el CI sigue verde (job artefactos, sin cambios).

## 8. Lecciones del fix (DESPUÉS de implementar, obligatorio)

Orden correcto ante un fallo (nunca reescribir el spec para justificar la
solución):

1. **Clasificar**: ¿el spec era correcto? → solo código + test de
   regresión, sin tocar el spec. ¿el spec estaba mal/incompleto? →
   corregir spec + revalidar criterio (§7) ANTES de tocar código.
2. **Re-disparar**: cada fix re-ejecuta tests afectados + auditoría si
   toca sus disparadores (ver `.ai/agents.md` rol 3).
3. **Registrar** abajo con etiqueta `[LOCAL]` (vale para este spec) o
   `[GENERAL]` (candidata a `context.md` en el replan).

- Fix aplicado: correccion de `servir.ps1` — `Join-Path` con 2 hijos posicionales falla; anidado en 2 llamadas [LOCAL].
- Qué sección de este spec cambia por el fix: ninguna (el spec era correcto; bug solo en codigo nuevo).
- Test anti-regresión que lo cubre: corrida del lanzador en job + `Invoke-WebRequest` 200 a `/index.html` (§6).

**Hotfix (excepción explícita)**: si la urgencia impide el spec previo, se
aplica directo PERO deja trazabilidad (qué, por qué, riesgo) y tests
después, en el mismo día. Sin excepción silenciosa.
