# Memoria Persistente - Instrucciones de Uso

> Proyecto: **sitio-viajes**. En este proyecto no hay servidor MCP de
> memoria: no existen aqui tools `brain-ai_*`. La memoria es conceptual:
> el agente registra decisiones en el hilo y las promueve a
> `docs/CHANGELOG.md` (indice de lecciones) cuando son reutilizables.

## Cuándo guardar (conceptual, al cerrar una tarea)

DESPUÉS de cada tarea exitosa, anotar:
1. **Decisiones de código:** por qué se eligió X sobre Y
2. **Patrones de error:** qué falló y cómo se resolvió
3. **Preferencias del usuario:** qué le gusta, qué rechaza
4. **Configuraciones efectivas:** qué configuración funcionó
5. **Lecciones aprendidas:** qué haría diferente

## Cuándo buscar (conceptual, antes de decidir)

ANTES de generar código o tomar decisiones:
1. Releer `docs/CHANGELOG.md` (indice de lecciones) y el spec activo
2. Si hay coincidencia → usar la decisión pasada
3. Si hay contradicción → alertar al usuario
4. Si no hay nada → tomar nueva decisión y registrarla

## Categorías de memoria
- **decisión:** por qué se eligió una tecnología, patrón o aproximación
- **error:** qué falló, por qué falló, cómo se resolvió
- **configuración:** qué configuración funcionó (tests, modelos, reglas)
- **preferencia:** qué le gusta al usuario (idioma, estilo, formato)
- **lección:** qué haría diferente la próxima vez

## Qué (no) guardar
- Guardar: decisiones con evidencia (código, configuración, resultado) + tags.
- NO guardar: credenciales, tokens, API keys ni información personal
  sensible (vive en `.env`, que nunca se lee ni se commitea).

## Flujo conceptual
1. **Detecta** si la pregunta es sobre decisiones o configuración pasada
2. **Busca** en `docs/CHANGELOG.md` + specs previos
3. **Si hay resultado** → úsalo como base
4. **Si no hay resultado** → responde con incertidumbre ("no tengo información previa")
5. **Si tomas una decisión importante** → regístrala en el hilo y
   promuévela a `docs/CHANGELOG.md` si es reutilizable
