# Módulo AI (.AIAgents)

[🇬🇧 Read in English](README.md)

Módulo Markdown reutilizable para importar en cualquier proyecto de software.
Provee skills de workflow para el pipeline de planificación y skills por dominio para minimizar el uso de tokens por tarea.
Compatible con cuatro agentes de IA: Claude, Codex, Gemini y GitHub Copilot.

---

## Estructura

```
.AIAgents/
├── COMMANDS.md                    # Referencia de comandos (legacy)
├── ROUTING.md                     # Mapeo de agente a carpeta
│
├── _shared/templates/             # Plantillas base
│   ├── project-context-template.md
│   ├── command-template.md
│   ├── skill-template.md
│   └── spec-template.md
│
├── Claude/                        # Archivos fuente de Claude
│   ├── commands/                  # Slash commands (legacy, mantenidos por compatibilidad)
│   └── skills/
│       ├── scan/                  # Workflow: poblar project-context.md
│       ├── spec/                  # Workflow: escribir spec de feature o bug
│       ├── plan/                  # Workflow: plan de implementación por fases
│       ├── tasks/                 # Workflow: lista de tareas atómicas
│       ├── implement/             # Workflow: ejecutar tareas por dominio
│       ├── spec-review/           # Workflow: validar implementación vs spec
│       ├── fix/                   # Workflow: bug fix mínimo
│       ├── status/                # Workflow: snapshot del pipeline
│       ├── switch/                # Workflow: cambiar spec activa
│       ├── mkskill/               # Workflow: crear/actualizar un skill del proyecto
│       ├── harness/               # Workflow: configurar hooks de Claude Code
│       ├── backend/               # Dominio: tareas de backend
│       ├── frontend/              # Dominio: tareas de frontend
│       ├── data/                  # Dominio: capa de datos
│       ├── testing/               # Dominio: escritura de tests y cobertura
│       ├── devops/                # Dominio: CI/CD e infraestructura
│       └── architecture-review/   # Dominio: decisiones de arquitectura
│
├── Codex/                         # Archivos fuente de Codex
│   ├── commands/                  # Slash commands (mecanismo principal de Codex)
│   └── skills/                    # Skills por dominio
│
├── Gemini/                        # Archivos fuente de Gemini
│   ├── commands/                  # Slash commands (mecanismo principal de Gemini)
│   └── skills/                    # Skills por dominio
│
├── Copilot/                       # Archivos fuente de GitHub Copilot
│   ├── commands/                  # Plantillas de prompt (pegar en Copilot Chat)
│   │   ├── scan.md
│   │   ├── spec.md
│   │   ├── plan.md
│   │   ├── tasks.md
│   │   ├── implement.md
│   │   ├── fix.md
│   │   ├── status.md
│   │   ├── switch.md
│   │   └── mcp-create.md          # Configurador interactivo de servidores MCP
│   └── skills/                    # Skills por dominio (model-agnostic, con frontmatter YAML)
│
└── scripts/
    └── bootstrap-commands.sh
```

---

## Conceptos clave

### Skills de workflow (Claude Code)

Claude Code descubre skills desde `.claude/skills/*/SKILL.md` y los expone a través del Skill tool.
Cada skill de workflow es un prompt de acción autocontenido para un paso del pipeline de planificación:

| Skill          | Propósito                                                      |
|----------------|----------------------------------------------------------------|
| `scan`         | Poblar `.ai/project-context.md` a partir del repo             |
| `spec`         | Escribir spec de feature o bug, setear `.ai/current`          |
| `plan`         | Plan de implementación por fases a partir de la spec          |
| `tasks`        | Lista de tareas atómicas con asignación de dominio            |
| `implement`    | Ejecutar tareas dominio por dominio con sub-agentes           |
| `spec-review`  | Validar implementación contra criterios de la spec            |
| `fix`          | Bug fix mínimo; `--trace` para trazabilidad en specs/bugs     |
| `status`       | Snapshot del pipeline (solo lectura)                          |
| `switch`       | Cambiar spec activa sin volver a correr spec                  |
| `mkskill`      | Crear o actualizar un skill específico del proyecto           |
| `harness`      | Configurar hooks y permisos de Claude Code                    |

### Skills por dominio (todos los agentes)

Cada skill de dominio carga solo una sección de `project-context.md`, no el archivo completo.
Esto mantiene bajo el uso de tokens y mínimo el ruido de contexto.
Todos los skills de dominio incluyen frontmatter YAML (`name` + `description`) para auto-discovery nativo.

| Skill      | Lee                    |
|------------|------------------------|
| `backend`  | `[context.backend]`    |
| `frontend` | `[context.frontend]`   |
| `data`     | `[context.data]`       |
| `testing`  | `[context.testing]`    |
| `devops`   | `[context.devops]`     |

### Mecanismos por agente

| Agente  | Comandos de workflow   | Skills de dominio     | Archivo de config                 |
|---------|------------------------|-----------------------|-----------------------------------|
| Claude  | `.claude/skills/`      | `.claude/skills/`     | `CLAUDE.md`                       |
| Codex   | `.codex/commands/`     | `.codex/skills/`      | `AGENTS.md`                       |
| Gemini  | `.gemini/commands/`    | `.gemini/skills/`     | `GEMINI.md`                       |
| Copilot | `.copilot/commands/` ¹ | `.github/skills/` ²   | `.github/copilot-instructions.md` |

¹ Copilot no tiene slash commands nativos — estos son plantillas de prompt para pegar en Copilot Chat.  
² Los skills en `.github/skills/` son auto-descubiertos por Copilot Agent Mode (VS Code). En chat regular, pegá el contenido del skill manualmente.

Claude Code usa el sistema nativo de skills (`skills/*/SKILL.md`) — aparecen en el contexto del sistema
y se invocan a través del Skill tool. Codex y Gemini usan slash commands cargados desde sus carpetas `commands/`.

### GitHub Copilot — features

**Skills (auto-discovery):** Los skills de dominio instalados en `.github/skills/` son activados automáticamente
por Copilot Agent Mode cuando tu prompt es relevante a un dominio. No hace falta cargarlos manualmente.

**Comandos (plantillas de prompt):** Los comandos de workflow son archivos Markdown que abrís y pegás en
Copilot Chat para ejecutar un paso del pipeline. Son model-agnostic — funcionan con GPT-4o, Claude Sonnet,
Gemini, o cualquier otro modelo que use Copilot.

**Servidores MCP (`mcp-create`):** Usá `.copilot/commands/mcp-create.md` para agregar un servidor MCP
al proyecto de forma interactiva. Copilot te pregunta si el servidor es remoto (HTTP) o local (npx/command),
recolecta los datos necesarios, y genera el entry correcto en `.vscode/mcp.json` sin hardcodear secrets
(usa referencias `${env:VAR}`).

---

## Uso sugerido

1. Copiá `.AIAgents/` en un proyecto destino.
2. Corré `./.AIAgents/scripts/bootstrap-commands.sh --repo <ruta-proyecto> --agent all --mode copy`.
3. Empezá cada sesión nueva con el skill `scan` para poblar `project-context.md`.
4. Usá los skills de workflow en orden: `scan` → `spec` → `plan` → `tasks` → `implement` → `spec-review`.
5. Para cada tarea de implementación, cargá solo el skill de dominio que corresponda a tu trabajo.
6. Actualizá `project-context.md` cuando cambien el stack, las integraciones o los estándares del proyecto.

### Opciones de bootstrap

```bash
# Todos los agentes
./.AIAgents/scripts/bootstrap-commands.sh --repo /ruta/proyecto --agent all --mode copy

# Un solo agente
./.AIAgents/scripts/bootstrap-commands.sh --repo /ruta/proyecto --agent copilot

# Modo symlink (los cambios en .AIAgents se propagan automáticamente)
./.AIAgents/scripts/bootstrap-commands.sh --repo /ruta/proyecto --agent all --mode link
```
