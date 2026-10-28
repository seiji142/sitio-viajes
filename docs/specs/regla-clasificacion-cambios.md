---
titulo: Regla de clasificacion de cambios (escaladores y modo con evidencia)
estado: implementado
entradas:
  - Regla ya vigente en gentle-ai, personalizar-comportamiento-01, gitflow-scaffold y banco-diseno
salidas:
  - .ai/commands.md con la seccion de clasificacion
  - opencode.json que carga .ai/commands.md
dependencias:
  - .ai/commands.md
  - opencode.json
tablas_impactadas: []
criterio_aceptacion: Al pedir un cambio que toca un escalador duro el agente exige spec antes de escribir, y un cambio chico se ejecuta sin documento.
---

# Regla de clasificacion de cambios

## 1. Problema

Este repo tiene gate pre-PR (checklist de sitio estatico) y gate pre-`main` con
OK visual, pero **no clasifica el cambio**: nada decide si hace falta spec.
Ademas `.ai/commands.md` **no esta en `instructions`** de `opencode.json`, asi
que una seccion escrita ahi nunca se cargaria. Y ninguno de los dos gates define
que cuenta como criterio: "publica" es una orden, no una aceptacion visual.

## 2. Alcance

- Incluye: seccion de clasificacion en `.ai/commands.md`, la aclaracion del
  criterio en el punto 6 de la checklist y en el gate pre-`main`, y la entrada
  en `instructions`.
- Excluye (explicito): la migracion de esquema de `opencode.json` que estaba
  sin commitear (`compaction`, `permission` -> `permissions`, `mcp` ->
  `mcp.servers`, `skills`). No se commitea aca ni se descarta.

## 3. Modulos / piezas

- `.ai/commands.md`: seccion nueva entre "Comandos slash custom" y "Validacion
  pre-PR"; 4 lineas en el punto 6 y 3 lineas en el gate pre-`main`.
- `opencode.json`: `.ai/commands.md` en `instructions` (unica linea commiteada).

## 4. Stack y dependencias

Markdown + JSON; sitio estatico HTML/CSS/JS. `scripts/ci_checks.py` valida
`opencode.json` (claves `model` e `instructions`), frontmatter de specs (6
campos + secciones `## 1.` a `## 8.`), skills y que los enlaces de
`docs/README.md` existan.

## 5. Diseno

Se copia la seccion **literal** desde `gentle-ai` (extraida por script, no
retecleada) para que las 5 copias se puedan comparar por contenido. Alternativa
descartada: reescribirla con el vocabulario visual de este repo - cada copia
divergente se desincroniza en silencio.

El gate pre-`main` recibe la aclaracion **ademas** del punto 6: es el gate que
dispara Pages, y es donde la orden de publicar se confunde mas facil con un OK
visual.

Para `opencode.json` se stagea el blob de HEAD + la linea nueva
(`hash-object` + `update-index --cacheinfo`): el commit contiene solo lo pedido
y el trabajo del usuario sigue intacto en el working tree.

## 6. Plan de verificacion

- Que ejecuta `fx-test`: `python -m json.tool opencode.json` y
  `python scripts/ci_checks.py` -> VERDE.
- Que revisa `my-review`: que la seccion sea identica a la de `gentle-ai`
  (comparacion de contenido), que el diff commiteado de `opencode.json` sea una
  sola linea, y que el working tree conserve la migracion sin commitear.

## 7. Criterio de aceptacion

Al pedir un cambio que toca un escalador duro el agente exige spec antes de
escribir, y un cambio chico se ejecuta sin documento.

## 8. Lecciones del fix (DESPUES de implementar, obligatorio)

- Fix aplicado [GENERAL]: el token `D2ED7B56DDEF894D` usado como sha de la
  seccion no es reproducible fuera de PowerShell: se midio con `Get-Content`,
  que decodifica en ANSI y manglea los acentos. Un hash medido con una
  herramienta que recodifica el texto no sirve como sello de contenido.
- Que seccion de este spec cambia por el fix: la §6, que ahora exige comparar
  contenido en vez de hashes externos.
- Test anti-regresion que lo cubre: el script de propagacion falla si la
  seccion de `gentle-ai` difiere de la ya propagada a `banco-diseno`.
