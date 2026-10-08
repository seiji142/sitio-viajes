# sitio-viajes

Sitio estatico de viajes (tutoriales web) en HTML5/CSS3/JS vanilla.
Agente especialista en tutoriales web con capa opcional de dominio YouTube
(MCP `youtube-transcripts` + gotchas + corpus en `docs/videos/`).

> Framework: adopcion del Nucleo de `personalizar-comportamiento-01`
> — **FRAMEWORK_VERSION instalada: 2026.10.05.2** (ver `docs/REUTILIZAR.md`
> del proyecto fuente). Capas: Nucleo (siempre) + dominio YouTube (pedido).
> Sin MCP `brain-ai`. Gitflow registrado 2026-10-07 en este proyecto:
> ramas `main`/`develop`, `VERSION 2026.10.05.1` (= scaffold, sin re-copies),
> flujo documentado en `.ai/context.md` (Ramas) y `.ai/commands.md`
> (Publicacion). Alcance: solo registro — sin publicar a `main`, sin deploy.
> Gitflow adoptado vía `/adoptar-gitflow`: `ci.yml` fusionado
> (`artefactos` + `build` mínimo sin Node) + `deploy.yml` (Pages, `src/`) +
> `scripts/gh-publish.ps1` — scaffold `gitflow-scaffold VERSION 2026.10.05.1`.

## Stack

- Frontend: HTML5, CSS3, JavaScript ES6+ (sin build, sin backend, sin BD)
- Dominio YouTube: MCP `youtube-transcripts` (ver `.ai/context.md` + `docs/videos/`)
- Modelo (`opencode.json`): `groq/openai/gpt-oss-20b`, permisos en `ask`

## Estructura

```
├── .ai/                  # Comportamiento del agente (system, rules, context, agents, commands, MEMORY)
├── .agents/skills/       # my-review, my-review-security, fx-test, fx-changelog, fx-replan
├── src/                  # index.html, destinos/, assets/{css,js,img}/
├── tests/                # Checks manuales (ver .ai/commands.md)
├── docs/                 # specs/PLANTILLA.md, CHANGELOG.md, videos/ (corpus YouTube)
├── scripts/              # ci_checks.py
├── .github/workflows/ci.yml  # Job artefactos (CI verde dia uno)
├── opencode.json         # Modelo + skills.paths + MCP youtube-transcripts
├── .env.example          # Plantilla (sin valores reales)
└── README.md             # Este archivo
```

## Uso

```bash
# Abrir en local (sin dependencias)
start src/index.html
# o con servidor estatico:
npx serve src

# CI de artefactos (stdlib)
python scripts/ci_checks.py
```

Copiar `.env.example` a `.env` y completar (el `.env` nunca se commitea ni se lee por el agente).

## Reglas del agente

Punto de entrada: `AGENTS.md` → archivos `.ai/`. Los 8 guardrails del
framework siguen presentes (`system.md` + `rules.md` §6–§8). Memoria
conceptual (sin MCP): ver `.ai/MEMORY.md` + `docs/CHANGELOG.md`.
