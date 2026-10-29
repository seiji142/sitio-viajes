---
titulo: Migracion de opencode.json al esquema v2 (compaction, skills, permissions, mcp.servers)
estado: implementado
entradas:
  - opencode.json de sitio-viajes en esquema v1 (compaction.prune, skills.paths, permission, mcp plano con enabled)
  - Patron ya mergeado en portfolio, flujo-ai-lab, piloto-nuevo y youtube-transcripts
  - Decision del humano: compaction.auto a true y los tres permisos con efecto allow
salidas:
  - opencode.json migrado a v2 sin claves de compatibilidad
  - docs/specs/migracion-esquema-opencode.md (este documento)
dependencias:
  - opencode.json
  - https://opencode.ai/config.json (schema v2)
  - scripts/ci_checks.py (gate local y CI del PR)
  - .agents/skills (registrado via `skills`)
tablas_impactadas: []
criterio_aceptacion: La config efectiva del archivo migrado es equivalente a la del v1 auto-migrado salvo los tres cambios declarados (regla edit duplicada que desaparece, compaction.auto a true y efecto de permisos a allow, los dos ultimos por decision humana), y `python scripts/ci_checks.py` queda verde.
---

# Migracion de opencode.json al esquema v2

## 1. Problema

`opencode.json` esta en el esquema v1: `compaction.prune`, `skills.paths`,
`permission` como objeto y `mcp.youtube-transcripts` plano con `enabled`.

OpenCode v2 **no rechaza** el archivo v1, lo migra en runtime. El defecto no
es una falla, es que este repo ensena el esquema viejo y depende de una capa
de compatibilidad. Medido en los cuatro repos hermanos ya migrados:

- La migracion automatica convierte `permission.write` a `edit` y lo suma al
  `edit` explicito: deja **la regla `edit` duplicada**.
- `compaction.prune` es una clave **deprecada** (el schema la marca
  `deprecated`). La doc v2 dice explicitamente: *"V1 used tail-turn and
  pruning behavior. V2 uses summaries and `compaction.keep.tokens`"*.
- `skills.paths` **sigue siendo valido** en v2 (el schema acepta array u
  objeto): convertirlo a array es cosmetico, no una migracion.
- `mcp.<nombre>` + `enabled: true` pasa a `mcp.servers.<nombre>`; la ausencia
  de `enabled` significa habilitado.

## 2. Alcance

- Incluye: las claves de `opencode.json` de este repo, la decision de
  `compaction.auto` y el efecto de los permisos (`ask` -> `allow`, decision
  del humano en el chat).
- Excluye (explicito): `model` e `instructions`; el contenido de `.ai/`,
  `.agents/skills/` y todo `src/` (HTML/CSS/JS del sitio).
- Excluye: la ruta y el comando del servidor MCP `youtube-transcripts`, que se
  conservan byte a byte y solo cambian de nivel; y los otros repos (los cuatro
  hermanos ya estan migrados).

## 3. Modulos / piezas

Un solo archivo, `opencode.json`:

| v1 (antes) | v2 (despues) |
|---|---|
| `compaction: {auto: false, prune: true}` | `compaction: {auto: true}` |
| `skills: {paths: ["..."]}` | `skills: ["..."]` |
| `permission` objeto (bash/webfetch/write/edit) | `permissions` array (shell/edit/webfetch) |
| `mcp.<nombre>` + `enabled: true` | `mcp.servers.<nombre>` sin `enabled` |

Ningun archivo de `src/` se toca: este cambio no es visual.

## 4. Stack y dependencias

Sitio estatico HTML5/CSS3/JS sin build (`src/`), y `scripts/ci_checks.py`
(cero dependencias, stdlib) como gate unico. El CI tiene el job `artefactos`
(que corre `ci_checks.py`) y un job `build` que solo hace checkout.

## 5. Diseno

Traduccion clave por clave segun `https://opencode.ai/config.json`, validada
contra la config efectiva y no contra el nombre que sugiere el schema.

Decisiones:

- **`compaction.auto: true`**: lo decide el humano. `prune` y `tail_turns`
  estan deprecados y sin equivalente; con `auto: false` el repo queda sin
  ningun mecanismo que libere contexto y la sesion puede morir por "too
  long". Alternativa descartada: `auto: false` + `keep.tokens`, que apaga la
  compactacion y solo fija cuanto contexto reciente se conserva.
- **`skills` a array**: en `flujo-ai-lab` se verifico que el array y el objeto
  `paths` producen **la misma config efectiva** (`opencode debug config`
  devuelve `[".agents/skills"]` en ambos casos). El cambio es cosmetico y se
  declara como tal.
- **`permission.write` no se reescribe aparte**: v2 usa `edit` para escritura
  y edicion; la regla `edit` ya cubre ambas y evita el duplicado que produce
  la compatibilidad.
- **Efecto `allow` en las tres reglas**: decision del humano en el chat (v1
  tenia las tres en `ask`). Consecuencia declarada: shell, edicion y webfetch
  dejan de pedir confirmacion en este repo. Las reglas del global siguen
  vigentes porque los arrays de `permissions` se concatenan y las del global
  se agregan despues.
- **MCP `youtube-transcripts` intacto**: es dominio de este repo (capa de
  YouTube documentada en `context.md`), no una clave de esquema. Solo cambia
  de nivel.

## 6. Plan de verificacion

1. `python -m json.tool opencode.json` -> exit 0.
2. `python scripts/ci_checks.py` -> `CI VERDE` (gate local y CI del PR).
3. `opencode debug config` en el worktree -> el documento del proyecto declara
   `permissions` (shell/edit/webfetch = allow), `skills: [".agents/skills"]`,
   `compaction: {auto: true}` y `mcp.servers: [youtube-transcripts]`.
4. Equivalencia contra el v1 auto-migrado (`git show HEAD:opencode.json` en un
   directorio temporal), comparando config efectiva normalizada: `model`,
   `skills`, `instructions`, `mcp` iguales; `permissions` sin reglas perdidas
   ni agregadas (solo desaparece el `edit` duplicado y cambia el efecto);
   `compaction.auto` difiere por decision humana.
5. Checklist visual (puntos 1-5 de `.ai/commands.md`): **NO APLICA**, el
   cambio no toca HTML, CSS, JS, imagenes ni videos; `git diff --stat` debe
   mostrar solo `opencode.json` y este spec.

## 7. Criterio de aceptacion

La config efectiva del archivo migrado es equivalente a la del v1
auto-migrado salvo los tres cambios declarados (regla `edit` duplicada que
desaparece, `compaction.auto` a `true` y efecto de permisos a `allow`, los dos
ultimos por decision humana), y `python scripts/ci_checks.py` queda verde.

## 8. Lecciones del fix (DESPUES de implementar, obligatorio)

- Fix aplicado [GENERAL]: no todo lo que difiere entre v1 y v2 es una
  migracion. `skills.paths` sigue siendo valido y `compaction.prune` es
  deprecado: convertir lo primero es cosmetico y quitar lo segundo cambia
  comportamiento, asi que se separa "traduccion de esquema" de "decision de
  producto" y la segunda la firma el humano.
- Fix aplicado [LOCAL]: el cambio no es visual, aunque la checklist del repo
  sea de sitio estatico. Se declaro NO APLICA en §6 y se verifico que
  `git diff --stat` solo lista `opencode.json` y el spec, para no arrastrar
  una revision de navegador que no mide nada.
- Que seccion de este spec cambia por el fix: §2 y §5, que declaran
  `compaction.auto` y el efecto `allow` como decision humana y no como parte
  del esquema; §6 incorpora la aclaracion de la checklist visual.
- Test anti-regresion que lo cubre: el paso 4 de §6 compara la config
  efectiva del archivo nuevo contra la del v1 auto-migrado; si alguien vuelve
  a mover `skills`, pierde el MCP o duplica reglas, la comparacion deja de dar
  iguales. `python scripts/ci_checks.py` valida ademas JSON, skills, indice de
  docs y frontmatter/secciones de los specs.
