# Contexto adicional (stack, esquema de BD, etc.)

## Stack Tecnologico
- Frontend: HTML5, CSS3, JavaScript ES6+ (sitio estatico, sin build)
- Backend: ninguno (estatico; formularios via `mailto:` o servicio externo si el spec lo pide)
- Base de datos: ninguna
- Otros: MCP `youtube-transcripts` (capa de dominio YouTube, opcional instalada)

## Arquitectura del Sistema
Sitio estatico multipagina en `src/` (`index.html`, `destinos/`, `assets/css/`,
`assets/js/`). Sin bundler ni backend: se abre directo en el navegador o
con un servidor estatico local. Estilos mobile-first en un solo
`assets/css/main.css`; JS progresivo en `assets/js/main.js`.

## Dependencias Principales
- Ninguna (HTML/CSS/JS vanilla). Si se agrega npm, fijarlo aqui + `package.json`.

## Variables de Entorno Requeridas
- SITE_URL=[url publica del sitio, ej: https://usuario.github.io/sitio-viajes]
- CONTACT_EMAIL=[email de contacto del formulario]
- YOUTUBE_CACHE_TTL_DAYS=[dias de vigencia de la cache de transcripciones, default 7]

## Convenciones de Archivos

| Tipo | Destino | Ejemplo |
|------|---------|---------|
| Paginas HTML | `src/` | `src/index.html`, `src/destinos/paris.html` |
| Estilos | `src/assets/css/` | `src/assets/css/main.css` |
| Scripts | `src/assets/js/` | `src/assets/js/main.js` |
| Imagenes | `src/assets/img/` | `src/assets/img/hero.jpg` |
| Specs | `docs/specs/` | `docs/specs/pagina-destino.md` |
| Videos/corpus YouTube | `docs/videos/` | `docs/videos/corpus/*.md` |
| Scripts utilitarios | `scripts/` | `scripts/ci_checks.py` |

## Herramientas MCP de YouTube (capa de dominio instalada)

Servidor `youtube-transcripts` (registrado en `opencode.json`).

| Tool | Para que |
|------|----------|
| `youtube_transcript` | Extraer transcripcion (devuelve `processing` + `job_id` si no hay captions) |
| `youtube_transcript_status` | Estado de un job ASR (`job_id` o URL) |
| `youtube_transcript_read` | Leer tramo por segundos (`start`/`end`/`max_chars`) — verificacion de tramos dudosos |
| `youtube_transcript_search` | Busqueda BM25 con citas `&t=` (requiere transcripcion previa) |
| `youtube_transcript_summary` | Idea central: secciones + overall con citas `&t=` |
| `youtube_health` | Diagnostico: proveedores, breakers, metricas |

## Gotchas de YouTube

- La **cache** vive en el repo `youtube-transcripts` (`data/`, SQLite):
  videos ya consultados responden offline.
- `status=processing` → llamar `youtube_transcript_status` con `job_id`;
  no reintentar `youtube_transcript` a ciegas.
- **Rate-limit de YouTube (429):** no sondear en rafaga; respetar pausas
  ante errores de bloqueo.
- Videos >2h, playlists y directos son rechazados por diseño.
- Referencia completa: `docs/videos/LECCIONES-youtube.md` + `docs/videos/corpus/`.

## Notas de Desarrollo
- Accesibilidad minima: `lang="es"`, `alt` en imagenes, contraste AA,
  navegacion por teclado en menus.
- Responsive: mobile-first, breakpoint base 768px.
